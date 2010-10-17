#!/bin/bash

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

TDBTMP=`mktemp -d`
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 $GIT_URL $TDBTMP

mv $TDBTMP/lib/tdb "tdb-$version"
mkdir "tdb-$version/lib"
mv $TDBTMP/buildtools "tdb-$version/buildtools"
mv $TDBTMP/lib/replace "tdb-$version/lib/replace"
ln -sf buildtools/scripts/autogen-waf.sh "tdb-$version/autogen-waf.sh"
rm -rf $TDBTMP
pushd "tdb-$version" && ./autogen.sh && popd
tar cvz "tdb-$version" > "tdb_$version.orig.tar.gz"
rm -rf "tdb-$version"
