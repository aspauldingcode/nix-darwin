{ config, lib, ... }:

with lib;

{
  options = {
    Label = mkOption {
      type = types.str;
      description = ''
        This required key uniquely identifies the job to launchd.
      '';
    };

    Disabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key is used as a hint to launchctl(1) that it should not submit this job to launchd when
        loading a job or jobs. The value of this key does NOT reflect the current state of the job on the run-ning running
        ning system. If you wish to know whether a job is loaded in launchd, reading this key from a configura-tion configuration
        tion file yourself is not a sufficient test. You should query launchd for the presence of the job using
        the launchctl(1) list subcommand or use the ServiceManagement framework's SMJobCopyDictionary() method.

        Note that as of Mac OS X v10.6, this key's value in a configuration file conveys a default value, which
        is changed with the [-w] option of the launchctl(1) load and unload subcommands. These subcommands no
        longer modify the configuration file, so the value displayed in the configuration file is not necessar-ily necessarily
        ily the value that launchctl(1) will apply. See launchctl(1) for more information.

        Please also be mindful that you should only use this key if the provided on-demand and KeepAlive crite-ria criteria
        ria are insufficient to describe the conditions under which your job needs to run. The cost to have a
        job loaded in launchd is negligible, so there is no harm in loading a job which only runs once or very
        rarely.
      '';
    };

    UserName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        This optional key specifies the user to run the job as. This key is only applicable when launchd is
        running as root.
      '';
    };

    GroupName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        This optional key specifies the group to run the job as. This key is only applicable when launchd is
        running as root. If UserName is set and GroupName is not, the the group will be set to the default
        group of the user.
      '';
    };

    # TODO
    inetdCompatibility = mkOption {
      type = types.nullOr (types.attrsOf types.bool);
      default = null;
      example = { Wait = true; };
      description = ''
        The presence of this key specifies that the daemon expects to be run as if it were launched from inetd.

        This flag corresponds to the "wait" or "nowait" option of inetd. If true, then the listening
        socket is passed via the standard in/out/error file descriptors. If false, then accept(2) is
        called on behalf of the job, and the result is passed via the standard in/out/error descriptors.
      '';
    };

    LimitLoadToHosts = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        This configuration file only applies to the hosts listed with this key. Note: One should set kern.host-name kern.hostname
        name in sysctl.conf(5) for this feature to work reliably.
      '';
    };

    LimitLoadFromHosts = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        This configuration file only applies to hosts NOT listed with this key. Note: One should set kern.host-name kern.hostname
        name in sysctl.conf(5) for this feature to work reliably.
      '';
    };

    LimitLoadToSessionType = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        This configuration file only applies to sessions of the type specified. This key is used in concert
        with the -S flag to launchctl.
      '';
    };

    Program = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        This key maps to the first argument of execvp(3).  If this key is missing, then the first element of
        the array of strings provided to the ProgramArguments will be used instead.  This key is required in
        the absence of the ProgramArguments key.
      '';
    };

    ProgramArguments = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        This key maps to the second argument of execvp(3).  This key is required in the absence of the Program
        key. Please note: many people are confused by this key. Please read execvp(3) very carefully!
      '';
    };

    EnableGlobbing = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This flag causes launchd to use the glob(3) mechanism to update the program arguments before invoca-tion. invocation.
        tion.
      '';
    };

    EnableTransactions = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This flag instructs launchd that the job promises to use vproc_transaction_begin(3) and
        vproc_transaction_end(3) to track outstanding transactions that need to be reconciled before the
        process can safely terminate. If no outstanding transactions are in progress, then launchd is free to
        send the SIGKILL signal.
      '';
    };

    OnDemand = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This key was used in Mac OS X 10.4 to control whether a job was kept alive or not. The default was
        true.  This key has been deprecated and replaced in Mac OS X 10.5 and later with the more powerful
        KeepAlive option.
      '';
    };

    KeepAlive = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key is used to control whether your job is to be kept continuously running or to let
        demand and conditions control the invocation. The default is false and therefore only demand will start
        the job. The value may be set to true to unconditionally keep the job alive. Alternatively, a dictio-nary dictionary
        nary of conditions may be specified to selectively control whether launchd keeps a job alive or not. If
        multiple keys are provided, launchd ORs them, thus providing maximum flexibility to the job to refine
        the logic and stall if necessary. If launchd finds no reason to restart the job, it falls back on
        demand based invocation.  Jobs that exit quickly and frequently when configured to be kept alive will
        be throttled to converve system resources.
      '';
    };

    RunAtLoad = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key is used to control whether your job is launched once at the time the job is loaded.
        The default is false.
      '';
    };

    RootDirectory = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        This optional key is used to specify a directory to chroot(2) to before running the job.
      '';
    };

    WorkingDirectory = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        This optional key is used to specify a directory to chdir(2) to before running the job.
      '';
    };

    EnvironmentVariables = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      default = null;
      description = ''
        This optional key is used to specify additional environmental variables to be set before running the
        job.
      '';
    };

    Umask = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        This optional key specifies what value should be passed to umask(2) before running the job. Known bug:
        Property lists don't support octal, so please convert the value to decimal.
      '';
    };

    TimeOut = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The recommended idle time out (in seconds) to pass to the job. If no value is specified, a default time
        out will be supplied by launchd for use by the job at check in time.
      '';
    };

    ExitTimeOut = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The amount of time launchd waits before sending a SIGKILL signal. The default value is 20 seconds. The
        value zero is interpreted as infinity.
      '';
    };

    ThrottleInterval = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        This key lets one override the default throttling policy imposed on jobs by launchd.  The value is in
        seconds, and by default, jobs will not be spawned more than once every 10 seconds.  The principle
        behind this is that jobs should linger around just in case they are needed again in the near future.
        This not only reduces the latency of responses, but it encourages developers to amortize the cost of
        program invocation.
      '';
    };

    InitGroups = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key specifies whether initgroups(3) should be called before running the job.  The default
        is true in 10.5 and false in 10.4. This key will be ignored if the UserName key is not set.
      '';
    };

    WatchPaths = mkOption {
      type = types.nullOr (types.listOf types.path);
      default = null;
      description = ''
        This optional key causes the job to be started if any one of the listed paths are modified.
      '';
    };

    QueueDirectories = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        Much like the WatchPaths option, this key will watch the paths for modifications. The difference being
        that the job will only be started if the path is a directory and the directory is not empty.
      '';
    };

    StartOnMount = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key causes the job to be started every time a filesystem is mounted.
      '';
    };

    StartInterval = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        This optional key causes the job to be started every N seconds.  If the system is asleep, the job will
        be started the next time the computer wakes up.  If multiple intervals transpire before the computer is
        woken, those events will be coalesced into one event upon wake from sleep.
      '';
    };

    # TODO
    StartCalendarInterval = mkOption {
      type = types.nullOr (types.attrsOf types.int);
      default = null;
      example = { Hour = 2; Minute = 30; };
      description = ''
        This optional key causes the job to be started every calendar interval as specified. Missing arguments
        are considered to be wildcard. The semantics are much like crontab(5).  Unlike cron which skips job
        invocations when the computer is asleep, launchd will start the job the next time the computer wakes
        up.  If multiple intervals transpire before the computer is woken, those events will be coalesced into
        one event upon wake from sleep.

           Minute <integer>
           The minute on which this job will be run.

           Hour <integer>
           The hour on which this job will be run.

           Day <integer>
           The day on which this job will be run.

           Weekday <integer>
           The weekday on which this job will be run (0 and 7 are Sunday).

           Month <integer>
           The month on which this job will be run.
      '';
    };

    StandardInPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        This optional key specifies what file should be used for data being supplied to stdin when using
        stdio(3).
      '';
    };

    StandardOutPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        This optional key specifies what file should be used for data being sent to stdout when using stdio(3).
      '';
    };

    StandardErrorPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        This optional key specifies what file should be used for data being sent to stderr when using stdio(3).
      '';
    };

    Debug = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key specifies that launchd should adjust its log mask temporarily to LOG_DEBUG while
        dealing with this job.
      '';
    };

    WaitForDebugger = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key specifies that launchd should instruct the kernel to have the job wait for a debugger
        to attach before any code in the job is executed.
      '';
    };

    # TODO
    SoftResourceLimits = mkOption {
      type = types.nullOr (types.attrsOf types.int);
      default = null;
    };

    # TODO
    HardResourceLimits = mkOption {
      type = types.nullOr (types.attrsOf types.int);
      default = null;
      example = { NumberOfFiles = 4096; };
      description = ''
        Resource limits to be imposed on the job. These adjust variables set with setrlimit(2).  The following
        keys apply:

           Core <integer>
           The largest size (in bytes) core file that may be created.

           CPU <integer>
           The maximum amount of cpu time (in seconds) to be used by each process.

           Data <integer>
           The maximum size (in bytes) of the data segment for a process; this defines how far a program may
           extend its break with the sbrk(2) system call.

           FileSize <integer>
           The largest size (in bytes) file that may be created.

           MemoryLock <integer>
           The maximum size (in bytes) which a process may lock into memory using the mlock(2) function.

           NumberOfFiles <integer>
           The maximum number of open files for this process.  Setting this value in a system wide daemon
           will set the sysctl(3) kern.maxfiles (SoftResourceLimits) or kern.maxfilesperproc (HardResource-Limits) (HardResourceLimits)
           Limits) value in addition to the setrlimit(2) values.

           NumberOfProcesses <integer>
           The maximum number of simultaneous processes for this user id.  Setting this value in a system
           wide daemon will set the sysctl(3) kern.maxproc (SoftResourceLimits) or kern.maxprocperuid
           (HardResourceLimits) value in addition to the setrlimit(2) values.

           ResidentSetSize <integer>
           The maximum size (in bytes) to which a process's resident set size may grow.  This imposes a
           limit on the amount of physical memory to be given to a process; if memory is tight, the system
           will prefer to take memory from processes that are exceeding their declared resident set size.

           Stack <integer>
           The maximum size (in bytes) of the stack segment for a process; this defines how far a program's
           stack segment may be extended.  Stack extension is performed automatically by the system.
      '';
    };

    Nice = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        This optional key specifies what nice(3) value should be applied to the daemon.
      '';
    };

    # TODO
    ProcessType = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Background";
      description = ''
        This optional key describes, at a high level, the intended purpose of the job.  The system will apply
        resource limits based on what kind of job it is. If left unspecified, the system will apply light
        resource limits to the job, throttling its CPU usage and I/O bandwidth. The following are valid values:

           Background
           Background jobs are generally processes that do work that was not directly requested by the user.
           The resource limits applied to Background jobs are intended to prevent them from disrupting the
           user experience.

           Standard
           Standard jobs are equivalent to no ProcessType being set.

           Adaptive
           Adaptive jobs move between the Background and Interactive classifications based on activity over
           XPC connections. See xpc_transaction_begin(3) for details.

           Interactive
           Interactive jobs run with the same resource limitations as apps, that is to say, none. Interac-tive Interactive
           tive jobs are critical to maintaining a responsive user experience, and this key should only be
           used if an app's ability to be responsive depends on it, and cannot be made Adaptive.
      '';
    };

    AbandonProcessGroup = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        When a job dies, launchd kills any remaining processes with the same process group ID as the job.  Set-ting Setting
        ting this key to true disables that behavior.
      '';
    };

    LowPriorityIO = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key specifies whether the kernel should consider this daemon to be low priority when
        doing file system I/O.
      '';
    };

    LaunchOnlyOnce = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        This optional key specifies whether the job can only be run once and only once.  In other words, if the
        job cannot be safely respawned without a full machine reboot, then set this key to be true.
      '';
    };

    # TODO
    MachServices = mkOption {
      type = types.nullOr (types.attrsOf types.bool);
      default = null;
      example = { ResetAtClose = true; };
      description = ''
        This optional key is used to specify Mach services to be registered with the Mach bootstrap sub-system.
        Each key in this dictionary should be the name of service to be advertised. The value of the key must
        be a boolean and set to true.  Alternatively, a dictionary can be used instead of a simple true value.

           ResetAtClose <boolean>
           If this boolean is false, the port is recycled, thus leaving clients to remain oblivious to the
           demand nature of job. If the value is set to true, clients receive port death notifications when
           the job lets go of the receive right. The port will be recreated atomically with respect to boot-strap_look_up() bootstrap_look_up()
           strap_look_up() calls, so that clients can trust that after receiving a port death notification,
           the new port will have already been recreated. Setting the value to true should be done with
           care. Not all clients may be able to handle this behavior. The default value is false.

           HideUntilCheckIn <boolean>
           Reserve the name in the namespace, but cause bootstrap_look_up() to fail until the job has
           checked in with launchd.

        Finally, for the job itself, the values will be replaced with Mach ports at the time of check-in with
        launchd.
      '';
    };

    # TODO
    Sockets = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = ''
        This optional key is used to specify launch on demand sockets that can be used to let launchd know when
        to run the job. The job must check-in to get a copy of the file descriptors using APIs outlined in
        launch(3).  The keys of the top level Sockets dictionary can be anything. They are meant for the appli-cation application
        cation developer to use to differentiate which descriptors correspond to which application level proto-cols protocols
        cols (e.g. http vs. ftp vs. DNS...).  At check-in time, the value of each Sockets dictionary key will
        be an array of descriptors. Daemon/Agent writers should consider all descriptors of a given key to be
        to be effectively equivalent, even though each file descriptor likely represents a different networking
        protocol which conforms to the criteria specified in the job configuration file.

        The parameters below are used as inputs to call getaddrinfo(3).

           SockType <string>
           This optional key tells launchctl what type of socket to create. The default is "stream" and
           other valid values for this key are "dgram" and "seqpacket" respectively.

           SockPassive <boolean>
           This optional key specifies whether listen(2) or connect(2) should be called on the created file
           descriptor. The default is true ("to listen").

           SockNodeName <string>
           This optional key specifies the node to connect(2) or bind(2) to.

           SockServiceName <string>
           This optional key specifies the service on the node to connect(2) or bind(2) to.

           SockFamily <string>
           This optional key can be used to specifically request that "IPv4" or "IPv6" socket(s) be created.

           SockProtocol <string>
           This optional key specifies the protocol to be passed to socket(2).  The only value understood by
           this key at the moment is "TCP".

           SockPathName <string>
           This optional key implies SockFamily is set to "Unix". It specifies the path to connect(2) or
           bind(2) to.

           SecureSocketWithKey <string>
           This optional key is a variant of SockPathName. Instead of binding to a known path, a securely
           generated socket is created and the path is assigned to the environment variable that is inher-ited inherited
           ited by all jobs spawned by launchd.

           SockPathMode <integer>
           This optional key specifies the mode of the socket. Known bug: Property lists don't support
           octal, so please convert the value to decimal.

           Bonjour <boolean or string or array of strings>
           This optional key can be used to request that the service be registered with the
           mDNSResponder(8).  If the value is boolean, the service name is inferred from the SockService-Name. SockServiceName.
           Name.

           MulticastGroup <string>
           This optional key can be used to request that the datagram socket join a multicast group.  If the
           value is a hostname, then getaddrinfo(3) will be used to join the correct multicast address for a
           given socket family.  If an explicit IPv4 or IPv6 address is given, it is required that the Sock-Family SockFamily
           Family family also be set, otherwise the results are undefined.
      '';
    };
  };

  config = {
  };
}
