===============================================================================
JENKINS BUILDOUT FOR PLONE PROJECTS
===============================================================================

.. note::

  This buildout is currently work-in-progress. If you depend on this buildout
  please keep in mind that variable names or entire sections might change in
  the future without announcement.

buildout.jenkins allows you to easiely set up a buildout that the Jenkins
CI-Server can use to generate reports for tests, test-coverage and
code-analysis.


Dependencies
============

Make sure that setuptools are installed or you will get the error
``AttributeError: 'NoneType' object has no attribute 'location'``.


Buildout
========

Create a jenkins.cfg that extends your existing buildout.cfg and set the
package-name parameter for the package that you want to be tested::

  [buildout]
  extends =
      buildout.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins.cfg

  package-name = plone.app.discussion
  package-directory = src/plone.app.discussion

If you want to run code analysis (e.g. PEP 8, PyFlakes, ZPTLint), you have to
include the code-coverage.cfg as well::

  [buildout]
  extends =
      buildout.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins.cfg
      https://raw.github.com/plone/buildout.jenkins/master/code-analysis.cfg

  package-name = plone.app.discussion
  package-directory = src/plone.app.discussion


Jenkins Job Shell Build Script
==============================

Configure a free-style Jenkins project and add a shell build script with the
following lines::

  python2.6 bootstrap.py
  bin/buildout -c jenkins.cfg

If you want Jenkins to run the test only, append the following line::

  bin/jenkins-test

If you want Jenkins to run the test together with a test-coverage analysis
(suitable for use with the Cobertura Plugin in Jenkins), append::

  bin/jenkins-test-coverage

If you want Jenkins to run a code analysis, append::

  bin/jenkins-code-analysis


Jenkins Configuration
=====================

For Jenkins to be able to understand the output of the tests and analyses,
you will need to configure your instance accordingly.

* Test results with ``bin/jenkins-test`` and ``bin/jenkins-test-coverage``:
    Configure your Jenkins project's options by enabling `Publish JUnit test
    result report` and setting `Test report XMLs` to be
    ``parts/jenkins-test/testreports/*.xml``.

* Test coverage with ``bin/jenkins-test-coverage``:
    Install and configure the **Cobertura Plugin** following `the instructions
    <https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin>`_, and
    configure your project's options such that you enable `Publish Cobertura
    Coverage Report` and set `Cobertura xml report pattern` to be
    ``parts/jenkins-test/coverage.xml``.


Plugins
=======

* Clonedigger - Setup of violations plugin:
    The final step, should be to bind the clonedigger's output with the
    Hudson. So, using the violations plugin, put the ``**/clonedigger.xml``
    string to the CPD field in the violations plugin setup. The clonedigger
    with ``--cpd-output`` will generate PMD's cpd similar output. (I hope
    there is no problem their XML schema in clonedigger).

    That should be all. Now run the build and watch for yourself! Enjoy.

    http://clonedigger.sourceforge.net/hudson_integration.html
