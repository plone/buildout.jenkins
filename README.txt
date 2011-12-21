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

