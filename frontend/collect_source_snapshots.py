#!/usr/bin/env python
# For each release version in src/index.xml
#  Download the non-existing zipballs from github and process them for source
#  release.
import sys
import os
try:
	from urllib2 import urlopen
except ImportError:
	# python3 support
	from urllib.request import urlopen
import xml.etree.ElementTree as etree
import atexit
import tempfile
import zipfile
import tarfile

from functools import partial

# base directory
project = 'py-postgresql'
script_dir = os.path.dirname(__file__)
os.chdir(script_dir)
files_dir = os.path.join(script_dir, 'static', 'files')
files = partial(os.path.join, files_dir)
idx = os.path.join(script_dir, 'src', 'index.xml')

def open_snapshot(bid, base_url = "http://github.com/jwp/py-postgresql/zipball/"):
	cwf = tempfile.TemporaryFile()
	url = base_url + bid
	sys.stderr.write("fetching from " + url + os.linesep)
	io = urlopen(url)
	data = io.read(2048)
	while data:
		cwf.write(data)
		data = io.read(2048)
	cwf.seek(0, 2)
	if cwf.tell() == 0:
		sys.stderr.write("no data available for " + base_url + bid + os.linesep)
		sys.exit(1)
	cwf.seek(0)
	return zipfile.ZipFile(cwf)

def extract(dst, zf):
	"""
	extract the contents of the zipfile into the dst directory.
	the directory acts the root directory in the zipfile itself.
	"""
	for x in zf.filelist:
		path = x.filename.split('/')[1:]
		rpath = os.path.join(dst, *path)
		if x.filename.endswith('/'):
			os.mkdir(rpath)
		else:
			f = open(rpath, 'w+b')
			f.write(zf.read(x.filename))
			f.close()

def rmrf(path):
	sys.stderr.write('[rm -rf ' + path + ']' + os.linesep)
	for root, dirs, files in os.walk(path, topdown = False):
		for name in files:
			f = os.path.join(root, name)
			os.remove(f)
		for name in dirs:
			f = os.path.join(root, name)
			os.rmdir(f)
	os.rmdir(path)

def allfiles(path):
	basename = os.path.basename(path)
	yield basename
	for root, dirs, files in os.walk(path, topdown = True):
		for d in dirs:
			yield os.path.join(root, d)
		for f in files:
			yield os.path.join(root, f)

def zipit(dst, src):
	zf = zipfile.ZipFile(dst, mode = 'w', compression = zipfile.ZIP_DEFLATED)
	for x in allfiles(src):
		zf.write(x)
	zf.close()

def gzipit(dst, src):
	gz = tarfile.open(dst, mode = 'w|gz')
	gz.add(src)
	gz.close()

def bzipit(dst, src):
	bz = tarfile.open(dst, mode = 'w|bz2')
	bz.add(src)
	bz.close()

added = []

for x in etree.parse(idx).getroot():
	main = x.attrib["id"]
	sys.stderr.write('checking ' + main + os.linesep)
	for r in x:
		bid = r.attrib['id']
		version = r.attrib['version']
		distname = project + '-' + version

		zip = files(distname + '.zip'), zipit
		tgz = files(distname + '.tar.gz'), gzipit
		tbz = files(distname + '.tar.bz2'), bzipit

		srcdir = os.path.join(script_dir, distname)
		fnp = ((zip, zipit), (tgz, gzipit), (tbz, bzipit))
		for (srcdist, proc) in [zip,tgz,tbz]:
			if os.path.exists(srcdist):
				sys.stderr.write(' found ' + srcdist + os.linesep)
				continue
			sys.stderr.write(' building ' + srcdist + os.linesep)
			if not os.path.exists(srcdir):
				# get the zipball
				b = open_snapshot(bid)
				# extract it into ./py-postgresql-<version>
				extract(srcdir, b)
				b.close()
				atexit.register(partial(rmrf, srcdir))
			added.append(srcdist)
			proc(srcdist, srcdir)

for x in added:
	sys.stdout.write(x + os.linesep)
