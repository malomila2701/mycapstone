When pulling project on MAC:
  in nbproject --> build-impl.xml 
  Add <target name="-post-compile">
        <copy todir="build/web/META-INF">
        <fileset dir="web/META-INF"/>
    </copy>
        <!-- Empty placeholder for easier customization. -->
        <!-- You can override this target in the ../build.xml file. -->
    </target>
