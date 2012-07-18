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
jenkins-test-eggs parameter for the egss you want to be tested and the
jenkins-test-directories for test coverage and code analysis::

  [buildout]
  extends =
      buildout.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins.cfg

  jenkins-test-eggs = plone.app.collection [test]
  jenkins-test-directories = src/plone.app.collection/plone/app/collection

If you want to run code analysis (e.g. PEP 8, PyFlakes, ZPTLint), you have to
include the jenkins-code-analysis.cfg as well::

  [buildout]
  extends =
      buildout.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins-code-analysis.cfg

  jenkins-test-eggs = plone.app.discussion [test]
  jenkins-test-directories = src/plone.app.collection/plone/app/collection

It is also possible to run jenkins-test and jenkins-code-coverage on multiple
packages::

  [buildout]
  extends =
      buildout.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins.cfg
      https://raw.github.com/plone/buildout.jenkins/master/jenkins-code-analysis.cfg

  jenkins-test-eggs =
      plone.app.collection [test]
      plone.app.contenttypes [test]
  jenkins-test-directories =
      src/plone.app.discussion/plone/app/discussion
      src/plone.app.contenttypes/plone/app/contenttypes


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

    Plugins recommended:

    * Cobertura Plugin `read Cobertura installation instructions
      <https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin>`_

    * Violations Plugin `read Violations installation instructions
      <https://wiki.jenkins-ci.org/display/JENKINS/Violations>`_

Post-build actions
==================

All items are added through the `Add post-build action` button in your
project.

**Publish JUnit test result report**
  Test report XMLs: ``parts/jenkins-test/testreports/*.xml``

**Publish Coberture Coverage Report**
  Cobertura xml report pattern: ``parts/jenkins-test/coverage.xml``
  Other options can stay on their default values

**Report Violations**
  Following reports are available for Violations plugin:

  * **csslint**

    XML filename pattern: ``parts/jenkins-test/xml-csslint/**/*.xml``

  * **jslint**

    XML filename pattern: ``parts/jenkins-test/xml-jshint/**/*.xml``

  * **jslint**

    XML filename pattern: ``parts/jenkins-test/**/jshint.xml``

  * **pep8**

    XML filename pattern: ``parts/jenkins-test/pep8.log``

  * **cpd**

    XML filename pattern: ``parts/jenkins-test/xml-clonedigger/**/clonedigger.xml``

  Clonedigger - Setup of violations plugin:
    The clonedigger with ``--cpd-output`` will generate PMD's cpd similar
    output. (I hope there is no problem their XML schema in clonedigger).

    http://clonedigger.sourceforge.net/hudson_integration.html

That should be all. Now run the build and watch for yourself! Enjoy.

Prerequisits
============

In order to be able to run some of the code analysis jobs you have to manually
install some dependencies on the Jenkins machine:

XMLLint
-------

On Debian/Ubuntu just install the libxml2-utils::

  $ sudo apt-get install libxml2-utils

OHCount
-------

On Debian/Ubuntu just install the ohcount package::

  $ sudo apt-get install ohcount

JSLint
------

On Debian/Ubuntu you can run jslint on nodejs::

  $ sudo apt-get install nodejs npm
  $ sudo npm install -g jslint

JSHint
------

On Debian/Ubuntu you can run jshint on nodejs::

  $ sudo apt-get install nodejs npm
  $ sudo npm install -g jshint

CSSLint
-------

On Debian/Ubuntu you can run csslint on nodejs::

  $ sudo apt-get install nodejs npm
  $ sudo npm install -g csslint
