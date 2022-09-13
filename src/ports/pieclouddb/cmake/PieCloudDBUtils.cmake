# Define pieclouddb feature macros
#
function(define_pieclouddb_features IN_VERSION OUT_FEATURES)
    # Pass values to caller
    set(${OUT_FEATURES} "${${OUT_FEATURES}}" PARENT_SCOPE)
endfunction(define_pieclouddb_features)

function(add_gppkg PDB_VERSION PDB_VARIANT PDB_VARIANT_SHORT UPGRADE_SUPPORT)
    string(TOLOWER ${PDB_VERSION} PDB_VERSION_LC)
    string(REPLACE "." "_" VERSION_ "${PDB_VERSION}")

    # Get information about the rhel version
    rh_version(RH_VERSION)
    string(REGEX MATCH "([0-9])" RH_MAJOR_VERSION "${RH_VERSION}")

    file(WRITE "${CMAKE_BINARY_DIR}/deploy/gppkg/${PDB_VARIANT}_${VERSION_}_gppkg.cmake" "
    file(MAKE_DIRECTORY
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/BUILD\"
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/SPECS\"
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/RPMS\"
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/gppkg\"
    )

    set(PDB_VERSION \"${PDB_VERSION}\")
    set(PDB_VERSION_LC \"${PDB_VERSION_LC}\")
    set(PDB_VARIANT \"${PDB_VARIANT}\")
    set(PDB_VARIANT_SHORT \"${PDB_VARIANT_SHORT}\")
    set(UPGRADE_SUPPORT \"${UPGRADE_SUPPORT}\")
    set(RH_MAJOR_VERSION \"${RH_MAJOR_VERSION}\")
    string(TOLOWER \"${PDB_VARIANT}\" PORT_NAME)

    configure_file(
        madlib.spec.in
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/SPECS/madlib.spec\"
    )
    configure_file(
        gppkg_spec.yml.in
        \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}/gppkg/gppkg_spec.yml\"
    )

    if(GPPKG_BINARY AND RPMBUILD_BINARY)
        add_custom_target(gppkg_${PDB_VARIANT}_${VERSION_}
            COMMAND cmake -E create_symlink \"\${MADLIB_GPPKG_RPM_SOURCE_DIR}\"
                \"\${CPACK_PACKAGE_FILE_NAME}-gppkg\"
            COMMAND \"\${RPMBUILD_BINARY}\" -bb SPECS/madlib.spec
            COMMAND cmake -E rename \"RPMS/\${MADLIB_GPPKG_RPM_FILE_NAME}\"
                \"gppkg/\${MADLIB_GPPKG_RPM_FILE_NAME}\"
            COMMAND \"\${GPPKG_BINARY}\" --build gppkg
            DEPENDS \"${CMAKE_BINARY_DIR}/\${CPACK_PACKAGE_FILE_NAME}.rpm\"
            WORKING_DIRECTORY \"\${CMAKE_CURRENT_BINARY_DIR}/${PDB_VERSION}\"
            COMMENT \"Generating ${PDB_VARIANT} ${PDB_VERSION} gppkg installer...\"
            VERBATIM
        )
    else(GPPKG_BINARY AND RPMBUILD_BINARY)
        add_custom_target(gppkg_${PDB_VARIANT}_${VERSION_}
            COMMAND cmake -E echo \"Could not find gppkg and/or rpmbuild.\"
                \"Please rerun cmake.\"
        )
    endif(GPPKG_BINARY AND RPMBUILD_BINARY)

    # Unfortunately, we cannot set a dependency to the built-in package target,
    # i.e., the following does not work:
    # add_dependencies(gppkg package)

    add_dependencies(gppkg gppkg_${PDB_VARIANT}_${VERSION_})
    ")
endfunction(add_gppkg)

