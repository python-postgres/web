#!/usr/bin/env python
# Build the docs of the latest release in each branch(src/index.xml).
import sys
import os
import zipfile
import xml.etree.ElementTree as etree

project = 'py-postgresql'
os.chdir(os.path.realpath(os.path.dirname(__file__)))
files = os.path.join('static', 'files')

def open_branch(version):
	zip = os.path.join(files, project + '-' + version + '.zip')
	return zipfile.ZipFile(zip)

def extract(dst, zf):
	"""
	extract the contents of the zipfile into the dst directory.
	the directory acts the root directory in the zipfile itself.
	"""
	for x in zf.filelist:
		path = x.filename.split('/')[1:]
		rpath = os.path.join(dst, *path)
		print(x.filename)
		if x.filename.endswith('/'):
			os.mkdir(rpath)
		else:
			f = open(rpath, 'w+b')
			f.write(zf.read(x.filename))
			f.close()

def rmrf(path, rm = os.remove, rmdir = os.rmdir, join = os.path.join):
	for root, dirs, files in os.walk(path, topdown = False):
		for name in files:
			rm(join(root, name))
		for name in dirs:
			rmdir(join(root, name))
	os.rmdir(path)

def publish_branch(target, version, d = 'tmpd'):
	if os.path.exists(d):
		rmrf(d)
	os.mkdir(d)
	open_branch(version).extractall(d)
	os.rename(os.path.join(d, project + '-' + version, 'postgresql', 'documentation', 'html'), target)
	rmrf(d)

if os.path.exists('docs'):
	rmrf('docs')
os.mkdir('docs')

for x in etree.parse('src/index.xml').getroot():
	if "documentation" in x.attrib:
		hasdocs = x.attrib["documentation"]
		if hasdocs.lower() == 'false':
			continue
	ver = x.attrib["version"]
	latest_ver = x[0].attrib["version"]
	d = os.path.join('docs', ver)
	if os.path.exists(d):
		rmrf(d)
	publish_branch(d, latest_ver)
