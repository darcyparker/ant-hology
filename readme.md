# ant-hology

[ant-hology](https://github.com/darcyparker/ant-hology) is a collection of
[apache ant](https://ant.apache.org/) tasks, targets, (etc...) that I frequently
use in my projects. (Particularly XSLT related tasks).

> My goal is have a general set of definitions that work on numerous platforms.
> So far, I have written & tested these on Windows 7, Linux (Debian) and OS X.
>
> Feedback is welcome! Please create pull requests and/or file issues as you
> find them. - _thanks_.

## Requirements

- Ant v1.9.1 or later _(I mostly use v1.9.2)_
  - Definitions imported from *ant-hology* make extensive use of ant's `if:*` and
  `unless:*` attributes which are available as of Ant 1.9.1.
- Recommended: `patch`, `cvs`, `svn` and `git` are used by some of the library getter
  targets.
  - I am assuming unix users already have or know how to install these
  - Windows users may need to install other required tools:
    - `patch` from http://gnuwin32.sourceforge.net/packages/patch.htm
    - `cvs` from http://ftp.gnu.org/non-gnu/cvs/binary/stable/x86-woe
    - `svn` from http://alagazam.net/
    - `git` from http://git-scm.com/downloads
- Other 3rd party library requirements can be installed using the getter targets
  in ant-hology. For example
  - `ant ant-hology.getAllLibraries` to get all libraries
  - or `ant ant-hology.get.calabash` to install calabash and its required
  libraries

  > In rare situations an `ant-hology.get.*` target may fail at a get task
  > because a URL is momentarily not reachable.  Simply running the target again
  > usually works.  If the target's get task persists to fail for the URL, the
  > URL may have changed.

## Setup in your project's build.xml

1. First, setup some initial directories:

   `ant-hology`

    > Example: You could add *ant-hology* as a subdirectory of your project with
    > `git submodule add git://github.com/darcyparker/ant-hology.git ant-hology`

    > Alternatively: You could clone or copy it elsewhere and point to it in
    > your project.

   `bin`

    > If you want to use a different `bin` dir than the default under
    > `${ant-hology.dir}`, set `${ant-hology.bin.dir}` before loading
    > `commonProperties.xml` in your project's `build` file.

   `lib`

    > If you want to use a different `lib` dir than the default under
    > ${ant-hology.dir}, set `${ant-hology.lib.dir}` before loading
    > `commonProperties.xml` in your project's `build` file.

   `temp`

   > Create a temp folder to store temporary files that *ant-hology* needs to
   > temporarily create and read. Set the `${ant-hology.temp.dir}` to point to
   > this directory.  If you are using .git, it is probably a good idea to add
   > this directory's content to your `.gitignore`.  As well, verify you have
   > read and write permissions to this directory.

   `XMLCatalog`

    > Example: `git submodule add git://github.com/darcyparker/XMLCatalog.git XMLCatalog`

    > Alternatively: You could clone or copy this XMLCatalog to another
    > location, or even use some other XMLCatalog.

    > Set the `${xmlcatalog.dir}` property in your project to point to your
    > xmlcatalog's location.

2. Next, add the following (or something similar) to your project's `build.xml`

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project
     name="test"
     basedir="."
     xmlns:if="ant:if"
     xmlns:unless="ant:unless"
     >

     <!--Store project's root directory in ${root.dir}-->
     <!--Note: It is a common convention to set the property ${root.dir} to your-->
     <!--build file's directory.  If you don't set `${xmlcatalog.dir}`, then the-->
     <!--default will be `${root.dir}/XMLCatalog`.  So in this default case,-->
     <!--ant-hology requires `${root.dir}` to be defined. If you don't define-->
     <!--`${root.dir}`, then be sure to explicitly define `${xmlcatalog.dir}` before-->
     <!--importing `commonProperties.xml`.-->
     <dirname property="root.dir" file="${ant.file.test}"/>

     <!--Optionally: Override some of anthology's defaults-->
     <!--Note: It's not strictly necessary to define `${ant-hology.dir}` because-->
     <!--when you import commonProperties.xml, commonProperties.xml will set it for-->
     <!--you if it is not set already.-->
     <property name="ant-hology.dir" location="${root.dir}/../ant-hology"/>
     <property name="xmlcatalog.dir" location="${root.dir}/../XMLCatalog"/>
     <property name="ant-hology.temp.dir" location="${root.dir}/temp"/>

     <!-- Import the common settings for ant-hology -->
     <import
       file="${ant-hology.dir}/commonProperties.xml"
       unless:set="ant-hology.commonProperties.loaded"/>

     <!--Install the minimum set of required libraries if they are not installed-->
     <ant
       unless:set="ant-hology.availableLibraries.allNecessaryLibs"
       antfile="${ant-hology.getLibraryDefs.dir}/allNecessaryLibs.xml"
       target="ant-hology.get.allNecessaryLibs"
       />

     <!--Import required items-->
     <!-- * In this case I am importing everything. But normally I would only-->
     <!--   import only what I need.-->
     <import
       file="${ant-hology.dir}/all.xml"
       unless:set="${ant-hology.all.loaded}"/>

     <!-- Continue your build.xml here. Define properties, targets, etc. -->

   </project>
   ```

## Some conventions and other notes

### commonProperties.xml

The [commonProperties.xml](commonProperties.xml/) file defines common properties
that are used by the  *ant-hology* definitions imported into your project.  Note
that all *ant-hology* properties are prefixed with `ant-hology.`.

The following are some of the properties defined in
[commonProperties.xml](commonProperties.xml/):

- `${ant-hology.dir}`is the ant-hology's root directory

  > Note: You can install *ant-hology* inside your project, or put it
  > outside your project so you can share *ant-hology* with many projects.

- `${ant-hology.lib.dir}` is where *ant-hology* will install and/or look for
  required libraries.
   > Default and *recommend* value is: `${ant-hology.dir}/lib`

   > Note: The lib directory does not have to be inside `${ant-hology.dir}`. For
   > example, you could set it to `${user.home}/lib`, however scripts in
   > `${ant-hology.dir}/bin` (or in other words this repo's [bin](bin/)
   > directory), expect their dependent libraries to be in
   > `${ant-hology.dir}/lib`.  So if the location of `${ant-hology.lib.dir}` is
   > different, then the scripts in `${ant-hology}/bin` will not work.  This is
   > only a problem if you wanted to use these scripts. If you are exclusively
   > using the *ant-hology* tasks and not the scripts in `${ant-hology}/bin`, then
   > this is acceptable.


- `${ant-hology.useBinDir}` can be `true` or `false`. It specifies whether or
  not *ant-hology* should create links to scripts and binaries in locations
  under `${ant-hology.lib.dir}` to the `${ant-hology.bin.dir}` directory. If
  `false`, no links will be created.

   > Default is: `true`

- `${ant-hology.bin.dir}` points to a bin directory with scripts you may use
  during development. *Ant-hology* has *getter* targets that may add symbolic
  links in this location.

  >Note: By default, `${ant-hology.bin.dir}` is set to the same directory as
  >`${ant-hology.dir}/bin`. (or in other words this repo's [bin](bin/) directory).

  >You can set `${ant-hology.bin.dir}` to a different value than
  >`${ant-hology.dir}/bin`, but it is usually not necessary.

- `${ant-hology.temp.dir}` points to a directory for temporary files that
  *ant-hology* may need to create.

  > Default is: `${ant-hology.dir}/temp`

  > Note: Your `clean` target should delete files in this directory.

- `${xmlcatalog.dir}` points to your xmlcatalog directory.

   > Default is under project's root dir: `${root.dir}/XMLCatalog`

### bin directory

The [bin](bin/) directory contains shell scripts for various tools inside the
library jars.  These scripts look for the libraries under
`${ant-hology.dir}/lib`.  So if you want to use these scripts, don't set
`${ant-hology.lib.dir}` before loading `commonProperties.xml`.

### getLibraries directory

The [getLibraries](getLibraries/) directory contains targets that can be used to
download and install 3rd party libraries that may be required by other tasks and
targets defined in this ant-hology.

### patches directory

The [patches](patches/) directory contains patches for some of the 3rd party
libraries used by ant-hology.

### paths directory

The [paths](paths/) directory contains path definitions that are used by targets
in [getLibrarires](getLibraries/) and [tasks](tasks/). Usually these path
definitions point to jar files in the libraries directory.

### tasks directory

The [tasks](tasks/) directory contains task definitions (including:
[macrodefs](https://ant.apache.org/manual/Tasks/macrodef.html),
[presetdefs](https://ant.apache.org/manual/Tasks/presetdef.html)
[scriptdefs](https://ant.apache.org/manual/Tasks/scriptdef.html) and
[taskdefs](https://ant.apache.org/manual/Tasks/taskdef.html))

The [tasks](tasks/) directory also contains
[scriptconditions](https://ant.apache.org/manual/Tasks/conditions.html#scriptcondition)
used by some tasks.

> In the future I may add
> [componentdefs](https://ant.apache.org/manual/Tasks/componentdef.html),
> [typedefs](https://ant.apache.org/manual/Tasks/typedef.html),
> [scriptfilters](https://ant.apache.org/manual/Types/filterchain.html#scriptfilter),
> [scriptmappers](https://ant.apache.org/manual/Types/mapper.html#script-mapper)
> and/or
> [scriptselectors](https://ant.apache.org/manual/Types/selectors.html#scriptselector)
> if I find a use for them.

<!-- End of file and vim modeline -->
<!-- vim: set et ts=2 sw=2 sts=2: -->
