Skip if setup is already done.

```
$ [[ "\${WORKSPACE:-}" == `pwd` ]] && return 0
```

Setup build environment.

```
$ cd edk2 || return 1
$ . edksetup.sh
$ make -C BaseTools
```

Update Conf/target.txt for our build target.

```
$ sed -i \
    -e "s#^ACTIVE_PLATFORM\s*=\s*[^[:space:]]\+#ACTIVE_PLATFORM = \${EDK2_ACTIVE_PLATFORM}#" \
    -e "s#^TARGET\s*=\s*[^[:space:]]\+#TARGET = \${EDK2_TARGET}#" \
    -e "s#^TARGET_ARCH\s*=\s*[^[:space:]]\+#TARGET_ARCH = \${EDK2_TARGET_ARCH}#" \
    -e "s#^TOOL_CHAIN_TAG\s*=\s*[^[:space:]]\+#TOOL_CHAIN_TAG = \${EDK2_TOOL_CHAIN_TAG}#" \
    Conf/target.txt
```
