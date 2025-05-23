#!/bin/bash -l
#
# DARWIN job script template, generated 2022-06-28T15:24:29-0400
#
# Sections of this script that can/should be edited are delimited by a
# [EDIT] tag.  All Slurm job options are denoted by a line that starts
# with "#SBATCH " followed by flags that would otherwise be passed on
# the command line.  Slurm job options can easily be disabled in a
# script by inserting a space in the prefix, e.g. "# SLURM " and
# reenabled by deleting that space.
#
# This is a batch job template for running GROMACS jobs on the cluster.
#
# [EDIT] There are several ways to communicate the number and layout
#        of worker processes.  Under GridEngine, the only option was
#        to request a number of slots and GridEngine would spread the
#        slots across an arbitrary number of nodes (not necessarily
#        with a common number of worker per node, either).  This method
#        is still permissible under Slurm by providing ONLY the
#        --ntasks option:
#
#             #SBATCH --ntasks=<nproc>
#
#        To limit the number of nodes used to satisfy the distribution
#        of <nproc> workers, the --nodes option can be used in addition
#        to --ntasks:
#
#             #SBATCH --nodes=1
#             #SBATCH --ntasks=<nproc>
#
#        in which case, <nproc> workers will be allocated to <nhosts>
#        nodes in round-robin fashion.
#
#        For a uniform distribution of workers the --tasks-per-node
#        option should be used with the --nodes option:
#
#             #SBATCH --nodes=1
#             #SBATCH --tasks-per-node=<nproc-per-node>
#
#        The --ntasks option can be omitted in this case and will be
#        implicitly equal to <nhosts> * <nproc-per-node>.
#
#        Given the above information, set the options you want to use
#        and add a space between the "#" and the word SBATCH for the ones
#        you don't want to use.
#
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#
# [EDIT] Normally, each MPI worker will not be multithreaded; if each
#        worker allows thread parallelism, then alter this value to
#        reflect how many threads each worker process will spawn.
#
#SBATCH --cpus-per-task=3
#
# [EDIT] All jobs have memory limits imposed.  The default is 1 GB per
#        CPU allocated to the job.  The default can be overridden either
#        with a per-node value (--mem) or a per-CPU value (--mem-per-cpu)
#        with unitless values in MB and the suffixes K|M|G|T denoting
#        kibi, mebi, gibi, and tebibyte units.  Delete the space between
#        the "#" and the word SBATCH to enable one of them:
#
# SBATCH --mem=8G
# SBATCH --mem-per-cpu=1024M
#
# [EDIT] Each node in the cluster has local scratch disk of some sort
#        that is always mounted as /tmp.  Per-job temporary directories
#        are automatically created and destroyed by Slurm and can be
#        referenced via the $TMPDIR environment variable.  To ensure a
#        minimum amount of free space when your job is scheduled, the
#        --tmp option can be used; it has the same behavior unit-wise as
#        --mem and --mem-per-cpu.  Delete the space between the "#" and the
#        word SBATCH to enable:
#
# SBATCH --tmp=24G
#
# [EDIT] It can be helpful to provide a descriptive (terse) name for
#        the job (be sure to use quotes if there's whitespace in the
#        name):
#
#SBATCH --job-name=75-0CL
#
# [EDIT] The partition determines which nodes can be used and with what
#        maximum runtime limits, etc.  Partition limits can be displayed
#        with the "sinfo --summarize" command.
#
#        PLEASE NOTE:  On DARWIN every job is **required** to include the
#                      --partition flag in its submission!
#
#SBATCH --partition=idle
# [EDIT] Jobs that will run in one of the GPU partitions can request GPU
#        resources using ONE of the following flags:
#
#          --gpus=<count>
#              <count> GPUs total for the job, regardless of node count
#          --gpus-per-node=<count>
#              <count> GPUs are required on each node allocated to the job
#          --gpus-per-socket=<count>
#              <count> GPUs are required on each socket allocated to the
#              job
#          --gpus-per-task=<count>
#              <count> GPUs are required for each task in the job
#
#       PLEASE NOTE:  On DARWIN the --gres flag should NOT be used to
#                     request GPU resources.  The GPU type will be
#                     inferred from the partition to which the job is
#                     submitted if not specified.
#
# SBATCH --gpus=1
# SBATCH --gpus-per-task=1
# SBATCH --gpus-per-node=1
# SBATCH --gpus-per-socket=2
#
# [EDIT] The maximum runtime for the job; a single integer is interpreted
#        as a number of minutes, otherwise use the format
#
#          d-hh:mm:ss
#
#        Jobs default to the default runtime limit of the chosen partition
#        if this option is omitted.
#
#SBATCH --time=3-00:00:00
# SBATCH --time=3-00:00:00
#        You can also provide a minimum acceptable runtime so the scheduler
#        may be able to run your job sooner.  If you do not provide a
#        value, it will be set to match the maximum runtime limit (discussed
#        above).
#
# SBATCH --time-min=0-01:00:00
#
# [EDIT] By default SLURM sends the job's stdout to the file "slurm-<jobid>.out"
#        and the job's stderr to the file "slurm-<jobid>.err" in the working
#        directory.  Override by deleting the space between the "#" and the
#        word SBATCH on the following lines; see the man page for sbatch for
#        special tokens that can be used in the filenames:
#
# SBATCH --output=%x-%j.out
# SBATCH --error=%x-%j.out
#
# [EDIT] Slurm can send emails to you when a job transitions through various
#        states: NONE, BEGIN, END, FAIL, REQUEUE, ALL, TIME_LIMIT,
#        TIME_LIMIT_50, TIME_LIMIT_80, TIME_LIMIT_90, ARRAY_TASKS.  One or more
#        of these flags (separated by commas) are permissible for the
#        --mail-type flag.  You MUST set your mail address using --mail-user
#        for messages to get off the cluster.
#
SBATCH --mail-user='nefratto@udel.edu'
SBATCH --mail-type=END,FAIL,TIME_LIMIT_90
#
# [EDIT] By default we DO NOT want to send the job submission environment
#        to the compute node when the job runs.
#
#SBATCH --export=NONE
#
#
# [EDIT] If you're not interested in how the job environment gets setup,
#        uncomment the following.
#
#UD_QUIET_JOB_SETUP=YES

#
# [EDIT] Define a Bash function and set this variable to its
#        name if you want to have the function called when the
#        job terminates (time limit reached or job preempted).
#
#        PLEASE NOTE:  when using a signal-handling Bash
#        function, any long-running commands should be prefixed
#        with UD_EXEC, e.g.
#
#                 UD_EXEC mpirun vasp
#
#        If you do not use UD_EXEC, then the signals will not
#        get handled by the job shell!
#
#job_exit_handler() {
#  # Copy all our output files back to the original job directory:
#  cp * "$SLURM_SUBMIT_DIR"
#
#  # Don't call again on EXIT signal, please:
#  trap - EXIT
#  exit 0
#}
#export UD_JOB_EXIT_FN=job_exit_handler

#
# [EDIT] By default, the function defined above is registered
#        to respond to the SIGTERM signal that Slurm sends
#        when jobs reach their runtime limit or are
#        preempted.  You can override with your own list of
#        signals using this variable -- as in this example,
#        which registers for both SIGTERM and the EXIT
#        pseudo-signal that Bash sends when the script ends.
#        In effect, no matter whether the job is terminated
#        or completes, the UD_JOB_EXIT_FN will be called.
#
#export UD_JOB_EXIT_FN_SIGNALS="SIGTERM EXIT"

#
# [EDIT] Slurm only sets SLURM_MEM_PER_CPU when the --mem-per-cpu option is
#        used.  The job template system will attempt to set the missing
#        SLURM_MEM_PER_CPU when --mem was used and the job has a uniform number
#        of tasks per node (the only case when per-node memory yields a
#        uniform memory per task/cpu) if this variable is set:
#UD_PREFER_MEM_PER_CPU=YES
#
#        Uncomment the following variable if the job mandates a per-CPU memory
#        limit to be present or calculable when UD_PREFER_MEM_PER_CPU is set:
#UD_REQUIRE_MEM_PER_CPU=YES
#
# [EDIT] Select the version of GROMACS you wish to use; do NOT provide the
#        precision and parallelism features, just the dotted version.
#
GROMACS_VERSION=2023.0

#
# [EDIT] Uncomment the next line and explicitly choose the parallelism
#        variety you'd like to use.  By default, the gromacs.sh script we
#        provide will choose "mpi" or "thread" based on the node count
#        in the Slurm runtime environment.
#
#GROMACS_PARALLELISM=mpi

#
# [EDIT] Select "single" or "double" precision numerics in the variant
#        of GROMACS loaded into the runtime environment:
#
GROMACS_PRECISION=single

#
# [EDIT] Some versions of GROMACS have been built with support for GPGPU
#        offload.  Set this variable to "sycl" or "cuda" to load that
#        specific variant into the runtime environment.
#
#        NOTE:  the "sycl" variants only support single-precision numerics
#
#GROMACS_GPU=sycl

#
# [EDIT] Add any flags you want to pass to the GROMACS executable; any
#        arguments with whitespace should be quoted, and put whitespace
#        between arguments.
#
#        E.g.
#
#           GROMACS_EXE_FLAGS=(this list "has whitespace" in "two options")
#
GROMACS_EXE_FLAGS=()

#
# [EDIT] Slurm has a specific MPI-launch mechanism in srun that can speed-up
#        the startup of jobs with large node/worker counts.  Uncomment this
#        line if you want to use that in lieu of mpirun.
#
#UD_USE_SRUN_LAUNCHER=YES

#
# [EDIT] By default each MPI worker process will be bound to a core/thread
#        for better efficiency.  Uncomment this to NOT affect such binding.
#
#UD_DISABLE_CPU_AFFINITY=YES

#
# [EDIT] MPI ranks are distributed <nodename>(<rank>:<socket>.<core>,..)
#
#    CORE    sequentially to all allocated cores on each allocated node in
#            the sequence they occur in SLURM_NODELIST (this is the default)
#
#              -N2 -n4 => n000(0:0.0,1:0.1,2:0.2,3:0.3); n001(4:0.0,5:0.1,6:0.2,7:0.3)
#
#    NODE    round-robin across the nodes allocated to the job in the sequence
#            they occur in SLURM_NODELIST
#
#              -N2 -n4 => n000(0:0.0,2:0.1,4:0.2,6:0.3); n001(1:0.0,3:0.1,5:0.2,7:0.3)
#
#    SOCKET  round-robin across the allocated sockets on each allocated node
#            in the sequence they occur in SLURM_NODELIST
#
#              -N2 -n4 => n000(0:0.0,2:0.1,4:1.0,6:1.1); n001(1:0.0,3:0.1,5:1.0,7:1.1)
#
#            PLEASE NOTE:  socket mode requires use of the --exclusive flag
#            to ensure uniform allocation of cores across sockets!
#
#UD_MPI_RANK_DISTRIB_BY=CORE

#
# [EDIT] By default all MPI byte transfers are limited to NOT use any
#        TCP interfaces on the system.  Setting this variable will force
#        the job to NOT use any Infiniband interfaces.
#
#UD_DISABLE_IB_INTERFACES=YES

#
# [EDIT] Should Open MPI display LOTS of debugging information as the job
#        executes?  Uncomment to enable.
#
#UD_SHOW_MPI_DEBUGGING=YES

#
# Do standard GROMACS environment setup
#
. /opt/shared/slurm/templates/libexec/gromacs.sh

#
# [EDIT] Do any pre-processing, staging, environment setup with VALET
#        or explicit changes to PATH, LD_LIBRARY_PATH, etc.
#

echo "-- GROMACS command line: $GROMACS_EXE ${GROMACS_EXE_FLAGS[@]}"
echo

#
# Execute GROMACS:
#
# THIS IS WHERE YOU ADD YOUR GROMACS COMMANDS!!
#$GROMACS_EXE "${GROMACS_EXE_FLAGS[@]}"
#$GROMACS_EXE grompp -f minim.mdp -c coordinate-file.gro -p topol.top -o em.tpr
#$GROMACS_EXE mdrun -deffnm em

$GROMACS_EXE grompp -f npt.mdp -c npt.gro -p topol.top -o out.tpr
$GROMACS_EXE mdrun -nt 3 -deffnm out
#$GROMACS_EXE mdrun -nt 3 -cpi sim1_out -deffnm sim1_out -append

gmx_rc=$?
echo
echo "-- GROMACS completed (rc = $gmx_rc)"

#
# [EDIT] Do any cleanup work here...
#

#
# Be sure to return the mpirun's result code:
#
exit $gmx_rc
