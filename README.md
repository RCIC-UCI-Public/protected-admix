# protected-admix
Admix for applications whose software source is protected by license

Source tarballs are held on UCI's CRSP server in the rcic-admin lab 
under the share/Software\ Downloads/protected-admix/

Simplest way forward when building is to sftp the entire protected-admix directory to the sources directory.

###  building QE as of 2024-11-26

The build no longer works and fails in fetching of wannier90 submodule during cmake command
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

Tested 2 ways of dealing with the error:

1. currently in place: 
   add chown command for external/wannier90
   this allowes git to proceed with the checkout.

2. comment line qe_git_submodule_update(external/wannier90) in external/wannier90.cmake
   add external/wannier90 contents for mthe tarball (save from working build)
   add wannier90.tar.gz to sources in save wannier repo changes its config.
