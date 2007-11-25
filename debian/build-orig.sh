#!/bin/sh
# Build a source tarball for tdb

samba_repos=svn://svn.samba.org/samba/
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )

if echo $version | grep svn > /dev/null; then
	# SVN Snapshot
	revno=`echo $version | sed 's/^[0-9.]\+~svn//'`
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/tdb tdb-$version
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/replace tdb-$version/libreplace
else
	# Release
	svn export $samba_repos/tags/TDB_`echo $version | sed 's/\./_/g'` tdb-$version
fi

cd tdb-$version && ./autogen.sh && cd ..
tar cvz tdb-$version > tdb_$version.orig.tar.gz
