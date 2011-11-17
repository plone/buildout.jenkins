===============================================================================
JENKINS BUILDOUT FOR PLONE PROJECTS
===============================================================================

Buildout
========

Create a jenkins.cfg that extends your existing buildout.cfg and set the 
package-name parameter for the package that you want to be tested.

  [buildout]
  extends =
      buildout.cfg
      https://github.com/plone/buildout.jenkins/blob/master/jenkins.cfg
  package-name = plone.app.discussion
  package-directory = plone/app/discussion


Jenkins Job Shell Build Script
==============================

Configure a free-style Jenkins project and add a shell build script with the
following lines:

  python2.6 bootstrap.py
  bin/buildout -c jenkins.cfg

If you want Jenkins to only run the test, append:

  bin/jenkins-test

If you want Jenkins to run the test together with a test-coverage analysis,
append:

  bin/jenkins-test-coverage

If you want Jenkins to run a code analysis, append:

  bin/jenkins-code-analysis
