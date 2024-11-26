# protected-admix
Admix for applications whose software source is protected by license

Source tarballs are held on UCI's CRSP server in the rcic-admin lab 
under the share/Software\ Downloads/protected-admix/

Simplest way forward when building is to sftp the entire protected-admix directory to the sources directory.

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
