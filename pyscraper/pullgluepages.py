#! /usr/bin/python2.3

import sys
import urllib
import urlparse
import re
import os.path
import xml.sax

toppath = os.path.expanduser('~/pwdata/')

# Pulls in all the debates, written answers, etc, glues them together, removes comments,
# and stores them on the disk

# index file which is created
pwcmindex = toppath + "pwcmindex.xml"

# output directories
pwcmdirs = toppath + "pwcmpages/"

pwcmwrans = pwcmdirs + "wrans/"
pwcmdebates = pwcmdirs + "debates/"
# statements and westminster hall

tempfile = toppath + "gluetemp"

# this does the main loading and gluing of the initial day debate files from which everything else feeds forward

# gets the index file which we use to go through the pages
class LoadCmIndex(xml.sax.handler.ContentHandler):
	def __init__(self, lpwcmindex):
		self.res = []
		if not os.path.isfile(lpwcmindex):
			return
		parser = xml.sax.make_parser()
		parser.setContentHandler(self)
		parser.parse(lpwcmindex)

	def startElement(self, name, attr):
		if name == "cmdaydeb":
			ddr = (attr["date"], attr["type"], attr["url"])
			self.res.append(ddr)



def WriteCleanText(fout, text):

	abf = re.split('(<[^>]*>)', text)
	for ab in abf:
		# delete comments and links
		if re.match('<!-[^>]*?->', ab):
			pass

		elif re.match('<a[^>]*>(?i)', ab):
			# this would catch if we've actually found a link
			if not re.match('<a name\s*?=\s*\S*?\s*?>(?i)', ab):
				print ab

		elif re.match('</a>(?i)', ab):
			pass

		# spaces only inside tags
		elif re.match('<[^>]*>', ab):
			fout.write(re.sub('\s', ' ', ab))

		# take out spurious > symbols and dos linefeeds
		else:
			fout.write(re.sub('>|\r', '', ab))


def GlueByNext(fout, url):
	while 1:
		print "reading " + url
		ur = urllib.urlopen(url)
		sr = ur.read()
		ur.close();

		# split by sections
		hrsections = re.split('<hr>(?i)', sr)

		# write the marker telling us which page this comes from
		fout.write('<page url="' + url + '"/>\n')

		# write the body of the text
		for i in range(1,len(hrsections) - 1):
			WriteCleanText(fout, hrsections[i])

		# find the lead on with the footer
		footer = hrsections[len(hrsections) - 1]

		# the files are sectioned by the <hr> tag into header, body and footer.
		nextsectionlink = re.findall('<\s*a\s+href\s*=\s*"?(.*?)"?\s*>next section</a>(?i)', footer)
		if not nextsectionlink:
			break
		if len(nextsectionlink) > 1:
			raise Exception, "More than one Next Section!!!"
		url = urlparse.urljoin(url, nextsectionlink[0])


# now we have the difficulty of pulling in the first link out of this silly index page
def ExtractFirstLink(url):
	urx = urllib.urlopen(url)
	while 1:
		xline = urx.readline()
		if not xline:
			break
		if re.search('<hr>(?i)', xline):
			break

	lk = []
	while xline:
		# <a HREF =" ../debtext/31106-01.htm#31106-01_writ0">Oral Answers to Questions </a>
		lk = re.findall('<a\s+href\s*=\s*"(.*?)">.*?</a>(?i)', xline)
		if lk:
			break
		xline = urx.readline()
	urx.close()

	if not lk:
		raise Exception, "No link found!!!"
	return urlparse.urljoin(url, re.sub('#.*$' , '', lk[0]))


# read through our index list of daydebates
def GlueAllType(pcmdir, cmindex, nametype, fproto):
	if not os.path.isdir(pcmdir):
		os.mkdir(pcmdir)

	for dnu in cmindex:
		# pick only the right type
		if not re.search(nametype, dnu[1]):
			continue

		# make the filename
		dgf = pcmdir + (fproto % dnu[0])
		print dgf

		# if we already have got the file, no need to scrape it in again
		if os.path.exists(dgf):
			continue

		print dnu[2]
		url0 = ExtractFirstLink(dnu[2])

		# now we take out the local pointer and start the gluing
		dtemp = open(tempfile, "w")
		GlueByNext(dtemp, url0)

		# close and move
		dtemp.close()
		os.rename(tempfile, dgf)



###############
# main function
###############
def PullGluePages():
	if not os.path.isdir(pwcmdirs):
		os.mkdir(pwcmdirs)

	ccmindex = LoadCmIndex(pwcmindex)

	# we're just working with written questions for now
	GlueAllType(pwcmwrans, ccmindex.res, 'answers(?i)', 'answers%s.html')

PullGluePages()