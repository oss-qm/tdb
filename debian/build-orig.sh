#!/bin/bash
REFSPEC=$1
GIT_URL=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

if [ -z "$REFSPEC" ]; then
	REFSPEC=origin/master
fi

TDBTMP=`mktemp -d`
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 -l $GIT_URL $TDBTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TDBTMP
	git checkout $REFSPEC || exit 1
	popd
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
