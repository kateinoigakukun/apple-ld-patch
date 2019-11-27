bootstrap: patch tapi llvm-project tapi/include/tapi/Version.inc mach-o/include/mach-o/dyld_priv.h
ld64:
	mkdir -p ld64 && \
	cd ld64 && \
	curl "https://opensource.apple.com/tarballs/ld64/ld64-450.3.tar.gz" \
	  | tar xz --strip-components 1

tapi:
	mkdir -p tapi && \
	cd tapi && \
	curl "https://opensource.apple.com/tarballs/tapi/tapi-1.30.tar.gz" \
	  | tar xz --strip-components 1

llvm-project:
	git clone https://github.com/llvm/llvm-project.git --depth 1

.PHONY: patch
patch: ld64 .patched/Options.cpp.patch .patched/project.pbxproj.patch
.patched:
	mkdir .patched
.patched/%.patch: diffs/%.patch .patched
	patch -d ld64 -p1 < $<
	touch $@

tapi/include/tapi/Version.inc:
	cp $@.in $@

mach-o/include/mach-o:
	mkdir -p mach-o/include/mach-o

mach-o/include/mach-o/dyld_priv.h: mach-o/include/mach-o
	curl https://opensource.apple.com/source/dyld/dyld-195.5/include/mach-o/dyld_priv.h -o $@

.PHONY: clean
clean:
	rm -rf ld64 llvm-project tapi .patch
