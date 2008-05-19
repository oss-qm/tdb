#!/bin/bash
REFSPEC=$1
GIT_URL=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

if [ -z "$REFSPEC" ]; then
	REFSPEC=origin/v4-0-test
fi

TDBTMP=$TMPDIR/$RANDOM.tdb.git
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 -l $GIT_URL $TDBTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TDBTMP
	git checkout $REFSPEC || exit 1
	popd
fi

mv $TDBTMP/source/lib/tdb "tdb-$version"
mv $TDBTMP/source/lib/replace "tdb-$version/libreplace"
rm -rf $TDBTMP
pushd "tdb-$version" && ./autogen.sh && popd
tar cvz "tdb-$version" > "tdb_$version.orig.tar.gz"
rm -rf "tdb-$version"
