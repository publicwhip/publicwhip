#! /usr/bin/python2.3

# Converts constituency XML file into a PHP array for canonicalising
# constituency names.

import xml.sax

class ConsConvert(xml.sax.handler.ContentHandler):
    id = ""
    canonical = ""

    def startElement(self, name, attr):
        if name == "constituency":
            self.id = attr["id"]

        elif name == "name":
            if self.canonical == "":
                self.canonical = attr["text"]
            print '"' + attr["text"].encode("latin-1") + '" => ',

    def endElement(self, name):
        if name == "name":
            print '"' + self.canonical.encode("latin-1") + '", '

        elif name == "constituency":
            self.id = ""
            self.canonical = ""


# Construct the global singleton of class which people will actually use
cc = ConsConvert()

print """<?php

# This file generated by cons2php.py from constituencies.xml.
# Edit the original (not this file), and rerun the script.

$consmatch = array("""

parser = xml.sax.make_parser()
parser.setContentHandler(cc)
parser.parse("constituencies.xml")

print """);

?>""";


