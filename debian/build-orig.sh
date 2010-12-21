#!/bin/bash

if [ -z "$SAMBA_GIT_URL" ]; then
	SAMBA_GIT_URL=git://git.samba.org/samba.git
fi

TDBTMP=`mktemp -d`
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
if [ -d $SAMBA_GIT_URL/.bzr ]; then
	bzr co --lightweight $SAMBA_GIT_URL $TDBTMP
else
	git clone --depth 1 $SAMBA_GIT_URL $TDBTMP
fi

mv $TDBTMP/lib/tdb "tdb-$version"
mkdir "tdb-$version/lib"
mv $TDBTMP/buildtools "tdb-$version/buildtools"
mv $TDBTMP/lib/replace "tdb-$version/lib/replace"
ln -sf buildtools/scripts/autogen-waf.sh "tdb-$version/autogen-waf.sh"
rm -rf $TDBTMP
pushd "tdb-$version" && ./autogen.sh && popd
tar cvz "tdb-$version" > "tdb_$version.orig.tar.gz"
rm -rf "tdb-$version"
