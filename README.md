# protected-admix
Admix for applications whose software source is protected by license

Source tarballs are held on UCI's CRSP server in the rcic-admin lab
under the share/Software-Downloads/protected-admix/

Simplest way forward when building is to sftp the entire protected-admix directory to the sources directory.
Add VASP sources tarballs under vasp/. See README there for details.

###  building QE as of 2024-11-26

The build no longer works and fails in fetching of wannier90 submodule during cmake command:
```txt
-- Installing Wannier90 via submodule
-- Cloning https://github.com/wannier-developers/wannier90.git into /export/repositories/protected-admix/BUILD/qe_7.1_gcc_11.2.0-7.1/qe-7.1/external/wannier90.
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint:
hint: 	git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint: 	git branch -m <name>
Initialized empty Git repository in /export/repositories/protected-admix/BUILD/qe_7.1_gcc_11.2.0-7.1/qe-7.1/external/wannier90/.git/
fatal: detected dubious ownership in repository at '/export/repositories/protected-admix/BUILD/qe_7.1_gcc_11.2.0-7.1/qe-7.1/external/wannier90'
```

Tested 2 ways of dealing with the error:

1. currently in place:
   - add chown command for external/wannier90, this allowes git to proceed with the checkout.

2. save working git repo checkout and disable git checkout during  the build:
   - comment line qe_git_submodule_update(external/wannier90) in external/wannier90.cmake (need a sed command in qe.yaml)
   - create a tarball wannier90.tar.gz from external/wannier90 (from working build)
   - add wannier90.tar.gz to the sources (to add in qe.yaml)
   - during the build add/uncompress wannier90.tar.gz to qe-topdir/external/wannier90 (to add in qe.yaml)

###  building VASP

As of Rocky Linux 9, add building vasp RPMS based on the notes in nfsapps-admix/yamlspecs/vasp/README.<vasp-version> files.

RPMS are installed only on devel host.
Copy installed binaries to HPC3 in /data/opt/apps/vasp/ under respective version
and chown to vasp specific group:

- for vasp/5.4.4 group vasp5
- for vasp/6.1.2 group vasp6
- for vasp/6.3.2 group vasp63

#### testing VASP

Tests are done on a devel host after RPMS are installed.
The outcome of the test can vary in a few digits on ech calculated number (compared to previous
runs for earlier OS). The results of tests for Rocky Linux 9 are listed below.

Get the test file (save in rcic-admin/share/Software-Downloads/protected-admix/):

```bash
wget https://hpc-uit.readthedocs.io/en/latest/_downloads/6582cc18a57df629960fb5cffe63af9c/CeO2.tar.gz -O CeO2.tar
gzip CeO2.tar
```

VASP 5.4.4
----------

```bash
tar xzf CeO2.tar.gz
cd CeO2job/
module load vasp/5.4.4
mpirun --allow-run-as-root vasp_std &> output-vasp5
```

Content of output-vasp5:
```text
 running on   32 total cores
 distrk:  each k-point on   32 cores,    1 groups
 distr:  one band on   16 cores,    2 groups
 using from now: INCAR
 vasp.5.4.4.18Apr17-6-g9f103f2a35 (build Jun  2 2025 10:32:10) complex
 POSCAR found :  2 types and     108 ions
 scaLAPACK will be used

 -----------------------------------------------------------------------------
|                                                                             |
|           W    W    AA    RRRRR   N    N  II  N    N   GGGG   !!!           |
|           W    W   A  A   R    R  NN   N  II  NN   N  G    G  !!!           |
|           W    W  A    A  R    R  N N  N  II  N N  N  G       !!!           |
|           W WW W  AAAAAA  RRRRR   N  N N  II  N  N N  G  GGG   !            |
|           WW  WW  A    A  R   R   N   NN  II  N   NN  G    G                |
|           W    W  A    A  R    R  N    N  II  N    N   GGGG   !!!           |
|                                                                             |
|      For optimal performance we recommend to set                            |
|        NCORE= 4 - approx SQRT( number of cores)                             |
|      NCORE specifies how many cores store one orbital (NPAR=cpu/NCORE).     |
|      This setting can  greatly improve the performance of VASP for DFT.     |
|      The default,   NCORE=1            might be grossly inefficient         |
|      on modern multi-core architectures or massively parallel machines.     |
|      Do your own testing !!!!                                               |
|      Unfortunately you need to use the default for GW and RPA calculations. |
|      (for HF NCORE is supported but not extensively tested yet)             |
|                                                                             |
 -----------------------------------------------------------------------------

 LDA part: xc-table for Pade appr. of Perdew
 POSCAR, INCAR and KPOINTS ok, starting setup
 FFT: planning ...
 WAVECAR not read
 entering main loop
       N       E                     dE             d eps       ncg     rms          rms(c)
DAV:   1     0.145409741873E+05    0.14541E+05   -0.29737E+05  1052   0.151E+03
DAV:   2     0.535903194822E+04   -0.91819E+04   -0.85408E+04  1180   0.424E+02
DAV:   3     0.481729059922E+03   -0.48773E+04   -0.47932E+04  1460   0.282E+02
DAV:   4    -0.942707269278E+03   -0.14244E+04   -0.13681E+04  1596   0.156E+02
DAV:   5    -0.110679934055E+04   -0.16409E+03   -0.16313E+03  1704   0.653E+01    0.153E+02
DAV:   6    -0.859119109333E+03    0.24768E+03   -0.19433E+03  1378   0.628E+01    0.654E+01
DAV:   7    -0.888603659245E+03   -0.29485E+02   -0.16451E+03  1824   0.855E+01    0.745E+01
DAV:   8    -0.860132569283E+03    0.28471E+02   -0.13636E+02  1640   0.249E+01    0.318E+01
DAV:   9    -0.850046553305E+03    0.10086E+02   -0.15072E+02  1672   0.190E+01    0.122E+01
DAV:  10    -0.850809012594E+03   -0.76246E+00   -0.21474E+01  1856   0.803E+00    0.127E+01
DAV:  11    -0.850391902354E+03    0.41711E+00   -0.94616E+00  2024   0.491E+00    0.541E+00
DAV:  12    -0.850520311672E+03   -0.12841E+00   -0.24029E+00  1960   0.305E+00    0.605E+00
DAV:  13    -0.850511189754E+03    0.91219E-02   -0.86093E-01  2064   0.155E+00    0.453E+00
DAV:  14    -0.850418867507E+03    0.92322E-01   -0.12779E+00  1848   0.224E+00    0.325E+00
DAV:  15    -0.850266186985E+03    0.15268E+00   -0.11039E+00  1760   0.201E+00    0.160E+00
DAV:  16    -0.850262804116E+03    0.33829E-02   -0.22228E-01  1768   0.900E-01    0.867E-01
DAV:  17    -0.850256216931E+03    0.65872E-02   -0.14380E-01  1856   0.617E-01    0.665E-01
DAV:  18    -0.850262379413E+03   -0.61625E-02   -0.80712E-02  1816   0.612E-01    0.108E+00
DAV:  19    -0.850246710580E+03    0.15669E-01   -0.24414E-01  1760   0.955E-01    0.142E+00
DAV:  20    -0.850233885416E+03    0.12825E-01   -0.41007E-02  1792   0.447E-01    0.534E-01
DAV:  21    -0.850242129602E+03   -0.82442E-02   -0.24042E-02  1768   0.287E-01    0.224E-01
DAV:  22    -0.850248959285E+03   -0.68297E-02   -0.72349E-03  1768   0.170E-01    0.110E-01
DAV:  23    -0.850252099213E+03   -0.31399E-02   -0.31097E-03  1720   0.943E-02    0.174E-01
DAV:  24    -0.850254675287E+03   -0.25761E-02   -0.21154E-03  1704   0.878E-02    0.582E-02
DAV:  25    -0.850260759812E+03   -0.60845E-02   -0.22930E-03  1584   0.776E-02    0.170E-01
DAV:  26    -0.850261423575E+03   -0.66376E-03   -0.71813E-04  1640   0.501E-02    0.852E-02
DAV:  27    -0.850261889690E+03   -0.46611E-03   -0.43853E-04  1648   0.343E-02    0.244E-02
DAV:  28    -0.850262042536E+03   -0.15285E-03   -0.76110E-05  1144   0.166E-02    0.203E-02
DAV:  29    -0.850262116377E+03   -0.73841E-04   -0.50328E-05  1096   0.156E-02    0.272E-02
DAV:  30    -0.850262131377E+03   -0.15000E-04   -0.19185E-05   808   0.121E-02    0.194E-02
DAV:  31    -0.850262133158E+03   -0.17803E-05   -0.10249E-05   688   0.727E-03
   1 F= -.85026213E+03 E0= -.85026213E+03  d E =-.562163E-11
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
```

VASP 6.1.2
----------

```bash
tar xzf CeO2.tar.gz
cd CeO2job/
module load vasp/6.1.2
mpirun --allow-run-as-root vasp_std &> output-vasp6
```

Content of output-vasp6:
```text
 running on   32 total cores
 distrk:  each k-point on   32 cores,    1 groups
 distr:  one band on   16 cores,    2 groups
 using from now: INCAR
 vasp.6.1.2 22Jul20 (build Jun  2 2025 10:47:52) complex
 POSCAR found :  2 types and     108 ions
 scaLAPACK will be used
 -----------------------------------------------------------------------------
|                                                                             |
|           W    W    AA    RRRRR   N    N  II  N    N   GGGG   !!!           |
|           W    W   A  A   R    R  NN   N  II  NN   N  G    G  !!!           |
|           W    W  A    A  R    R  N N  N  II  N N  N  G       !!!           |
|           W WW W  AAAAAA  RRRRR   N  N N  II  N  N N  G  GGG   !            |
|           WW  WW  A    A  R   R   N   NN  II  N   NN  G    G                |
|           W    W  A    A  R    R  N    N  II  N    N   GGGG   !!!           |
|                                                                             |
|     For optimal performance we recommend to set                             |
|       NCORE = 4 - approx SQRT(number of cores).                             |
|     NCORE specifies how many cores store one orbital (NPAR=cpu/NCORE).      |
|     This setting can greatly improve the performance of VASP for DFT.       |
|     The default, NCORE=1 might be grossly inefficient on modern             |
|     multi-core architectures or massively parallel machines. Do your        |
|     own testing!!!!                                                         |
|     Unfortunately you need to use the default for GW and RPA                |
|     calculations (for HF NCORE is supported but not extensively tested      |
|     yet).                                                                   |
|                                                                             |
 -----------------------------------------------------------------------------

 LDA part: xc-table for Pade appr. of Perdew
 POSCAR, INCAR and KPOINTS ok, starting setup
 FFT: planning ...
 WAVECAR not read
 entering main loop
       N       E                     dE             d eps       ncg     rms          rms(c)
DAV:   1     0.145409741873E+05    0.14541E+05   -0.29737E+05  1052   0.151E+03
DAV:   2     0.535903194822E+04   -0.91819E+04   -0.85408E+04  1180   0.424E+02
DAV:   3     0.481729059921E+03   -0.48773E+04   -0.47932E+04  1460   0.282E+02
DAV:   4    -0.942707269279E+03   -0.14244E+04   -0.13681E+04  1596   0.156E+02
DAV:   5    -0.110679934054E+04   -0.16409E+03   -0.16313E+03  1704   0.653E+01    0.153E+02
DAV:   6    -0.859119109324E+03    0.24768E+03   -0.19433E+03  1378   0.628E+01    0.654E+01
DAV:   7    -0.888603659326E+03   -0.29485E+02   -0.16451E+03  1824   0.855E+01    0.745E+01
DAV:   8    -0.860132569702E+03    0.28471E+02   -0.13636E+02  1640   0.249E+01    0.318E+01
DAV:   9    -0.850046552469E+03    0.10086E+02   -0.15072E+02  1672   0.190E+01    0.122E+01
DAV:  10    -0.850809011584E+03   -0.76246E+00   -0.21474E+01  1856   0.803E+00    0.127E+01
DAV:  11    -0.850391902038E+03    0.41711E+00   -0.94616E+00  2024   0.491E+00    0.541E+00
DAV:  12    -0.850520311810E+03   -0.12841E+00   -0.24029E+00  1960   0.305E+00    0.605E+00
DAV:  13    -0.850511190121E+03    0.91217E-02   -0.86093E-01  2064   0.155E+00    0.453E+00
DAV:  14    -0.850418868948E+03    0.92321E-01   -0.12779E+00  1848   0.224E+00    0.325E+00
DAV:  15    -0.850266186881E+03    0.15268E+00   -0.11039E+00  1760   0.201E+00    0.160E+00
DAV:  16    -0.850262803803E+03    0.33831E-02   -0.22228E-01  1768   0.900E-01    0.867E-01
DAV:  17    -0.850256216801E+03    0.65870E-02   -0.14380E-01  1856   0.617E-01    0.665E-01
DAV:  18    -0.850262379355E+03   -0.61626E-02   -0.80712E-02  1816   0.612E-01    0.108E+00
DAV:  19    -0.850246711265E+03    0.15668E-01   -0.24414E-01  1760   0.955E-01    0.142E+00
DAV:  20    -0.850233885534E+03    0.12826E-01   -0.41008E-02  1792   0.447E-01    0.534E-01
DAV:  21    -0.850242129837E+03   -0.82443E-02   -0.24043E-02  1768   0.287E-01    0.224E-01
DAV:  22    -0.850248959260E+03   -0.68294E-02   -0.72348E-03  1768   0.170E-01    0.110E-01
DAV:  23    -0.850252099418E+03   -0.31402E-02   -0.31100E-03  1720   0.943E-02    0.174E-01
DAV:  24    -0.850254675342E+03   -0.25759E-02   -0.21158E-03  1704   0.878E-02    0.583E-02
DAV:  25    -0.850260759582E+03   -0.60842E-02   -0.22929E-03  1584   0.776E-02    0.170E-01
DAV:  26    -0.850261423523E+03   -0.66394E-03   -0.71794E-04  1640   0.501E-02    0.852E-02
DAV:  27    -0.850261889600E+03   -0.46608E-03   -0.43851E-04  1648   0.343E-02    0.244E-02
DAV:  28    -0.850262042417E+03   -0.15282E-03   -0.76093E-05  1144   0.166E-02    0.203E-02
DAV:  29    -0.850262116288E+03   -0.73871E-04   -0.50335E-05  1096   0.156E-02    0.272E-02
DAV:  30    -0.850262131302E+03   -0.15014E-04   -0.19188E-05   808   0.121E-02    0.194E-02
DAV:  31    -0.850262133071E+03   -0.17696E-05   -0.10248E-05   688   0.727E-03
   1 F= -.85026213E+03 E0= -.85026213E+03  d E =-.562136E-11
Note: The following floating-point exceptions are signalling:Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
Note: The following floating-point exceptions are signalling: IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
 IEEE_UNDERFLOW_FLAG IEEE_DENORMAL
```

VASP 6.3.2
----------

```bash
tar xzf CeO2.tar.gz
cd CeO2job/
module load vasp/6.3.2/gcc.11.2.0
mpirun --allow-run-as-root -np 16 -x OMP_NUM_THREADS=1 vasp_std &> out-vasp63 &
```

Content of output-vasp5:
```text
nohup: ignoring input
 ----------------------------------------------------
    OOO  PPPP  EEEEE N   N M   M PPPP
   O   O P   P E     NN  N MM MM P   P
   O   O PPPP  EEEEE N N N M M M PPPP   -- VERSION
   O   O P     E     N  NN M   M P
    OOO  P     EEEEE N   N M   M P
 ----------------------------------------------------
 running   16 mpi-ranks, with    1 threads/rank
 distrk:  each k-point on   16 cores,    1 groups
 distr:  one band on    8 cores,    2 groups
 vasp.6.3.2 27Jun22 (build Jun  2 2025 10:59:02) complex
 POSCAR found :  2 types and     108 ions
 Reading from existing POTCAR
 scaLAPACK will be used
 Reading from existing POTCAR
 LDA part: xc-table for Pade appr. of Perdew
 POSCAR, INCAR and KPOINTS ok, starting setup
 FFT: planning ... GRIDC
 FFT: planning ... GRID_SOFT
 FFT: planning ... GRID
 WAVECAR not read
 entering main loop
       N       E                     dE             d eps       ncg     rms          rms(c)
DAV:   1     0.145409741873E+05    0.14541E+05   -0.29737E+05  1052   0.151E+03
DAV:   2     0.535903194823E+04   -0.91819E+04   -0.85408E+04  1180   0.424E+02
DAV:   3     0.481729059934E+03   -0.48773E+04   -0.47932E+04  1460   0.282E+02
DAV:   4    -0.942707269267E+03   -0.14244E+04   -0.13681E+04  1596   0.156E+02
DAV:   5    -0.110679934053E+04   -0.16409E+03   -0.16313E+03  1704   0.653E+01    0.153E+02
DAV:   6    -0.859119109290E+03    0.24768E+03   -0.19433E+03  1378   0.628E+01    0.654E+01
DAV:   7    -0.888603659235E+03   -0.29485E+02   -0.16451E+03  1824   0.855E+01    0.745E+01
DAV:   8    -0.860132569375E+03    0.28471E+02   -0.13636E+02  1640   0.249E+01    0.318E+01
DAV:   9    -0.850046553069E+03    0.10086E+02   -0.15072E+02  1672   0.190E+01    0.122E+01
DAV:  10    -0.850809012310E+03   -0.76246E+00   -0.21474E+01  1856   0.803E+00    0.127E+01
DAV:  11    -0.850391902257E+03    0.41711E+00   -0.94616E+00  2024   0.491E+00    0.541E+00
DAV:  12    -0.850520311685E+03   -0.12841E+00   -0.24029E+00  1960   0.305E+00    0.605E+00
DAV:  13    -0.850511189821E+03    0.91219E-02   -0.86093E-01  2064   0.155E+00    0.453E+00
DAV:  14    -0.850418867822E+03    0.92322E-01   -0.12779E+00  1848   0.224E+00    0.325E+00
DAV:  15    -0.850266186933E+03    0.15268E+00   -0.11039E+00  1760   0.201E+00    0.160E+00
DAV:  16    -0.850262804014E+03    0.33829E-02   -0.22228E-01  1768   0.900E-01    0.867E-01
DAV:  17    -0.850256216879E+03    0.65871E-02   -0.14380E-01  1856   0.617E-01    0.665E-01
DAV:  18    -0.850262379376E+03   -0.61625E-02   -0.80712E-02  1816   0.612E-01    0.108E+00
DAV:  19    -0.850246710735E+03    0.15669E-01   -0.24414E-01  1760   0.955E-01    0.142E+00
DAV:  20    -0.850233885431E+03    0.12825E-01   -0.41007E-02  1792   0.447E-01    0.534E-01
DAV:  21    -0.850242129652E+03   -0.82442E-02   -0.24042E-02  1768   0.287E-01    0.224E-01
DAV:  22    -0.850248959262E+03   -0.68296E-02   -0.72349E-03  1768   0.170E-01    0.110E-01
DAV:  23    -0.850252099234E+03   -0.31400E-02   -0.31098E-03  1720   0.943E-02    0.174E-01
DAV:  24    -0.850254675266E+03   -0.25760E-02   -0.21155E-03  1704   0.878E-02    0.582E-02
DAV:  25    -0.850260759745E+03   -0.60845E-02   -0.22930E-03  1584   0.776E-02    0.170E-01
DAV:  26    -0.850261423530E+03   -0.66379E-03   -0.71807E-04  1640   0.501E-02    0.852E-02
DAV:  27    -0.850261889655E+03   -0.46612E-03   -0.43853E-04  1648   0.343E-02    0.244E-02
DAV:  28    -0.850262042463E+03   -0.15281E-03   -0.76104E-05  1144   0.166E-02    0.203E-02
DAV:  29    -0.850262116339E+03   -0.73877E-04   -0.50328E-05  1096   0.156E-02    0.272E-02
DAV:  30    -0.850262131344E+03   -0.15004E-04   -0.19185E-05   808   0.121E-02    0.194E-02
DAV:  31    -0.850262133117E+03   -0.17734E-05   -0.10248E-05   688   0.727E-03
   1 F= -.85026213E+03 E0= -.85026213E+03  d E =-.562156E-11
```
