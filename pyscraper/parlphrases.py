#! /usr/bin/python2.3
# vim:sw=8:ts=8:et:nowrap

import cStringIO
import re



class ParlPhrases:
	jobs = [
	"Chief Secretary to the Treasury",
	"Deputy Prime Minister",
	"Prime Minister",
	"Economic Secretary to the Treasury",
	"Financial Secretary to Her Majesty's Treasury",
	"Financial Secretary to the Treasury",
	"Home Secretary",
	"International Development Secretary",
	"Minister for Barking",
	"Minister for Children at the Department for Education and Skills",
	"Minister for Disabled People",
	"Minister for Environment and Agri-Environment",
	"Minister for Europe",
	"Minister for Europe's office",
	"Minister for Europe, Foreign and Commonwealth Office",
	"Minister for Local Government",
	"Minister for Nature, Conservation and Fisheries",
	"Minister for State for Transport",
	"Minister for Transport",
	"Minister for the Cabinet Office",
	"Minister of State at DEFRA",
	"Minister of State at the Cabinet Office",
	"Minister of State at the Department for Environment, Food and Rural Affairs",
	"Minister of State at the Department of Trade and Industry",
	"Minister of State at the FCO",
	"Minister of State at the Foreign and Commonwealth Office",
	"Minister of State at the Home Office",
	"Minister of State for Crime Reduction, Policing and Community Safety at the Home Office",
	"Minister of State for Defence",
	"Minister of State for Environment and Agri-Environment",
	"Minister of State for Housing and Planning",
	"Minister of State for Rural Affairs",
	"Minister of State for Transport",
	"Minister of State for the Armed Forces",
	"Minister of State for the Cabinet Office",
	"Minister of State for the Home Department",
	"Minister of State in the Cabinet Office",
	"Minister of State, Cabinet Office",
	"Minister of State, Cabinet Office",
	"Minister of State, Department of Health",
	"Minister of State, Foreign and Commonwealth Office",
	"Minister of State",
	"Parliamentary Under Secretary for the Environment, Food and Rural Affairs",
	"Parliamentary Under Secretary of State at the Department for Education and Skills",
	"Parliamentary Under Secretary of State at the Department for International Development",
	"Parliamentary Under Secretary of State at the Foreign and Commonwealth Office",
	"Parliamentary Under Secretary of State for Defence",
	"Parliamentary Under Secretary of State for Work and Pensions",
	"Parliamentary Under Secretary of State for the Environment, Food and Rural Affairs",
	"Parliamentary Under-Secretary for Employment Relations, Competition and Consumers",
	"Parliamentary Under-Secretary for Health",
	"Parliamentary Under-Secretary for Public Health",
	"Parliamentary Under-Secretary for the Cabinet Office",
	"Parliamentary Under-Secretary of State at the Department for Environment, Food and Rural Affairs",
	"Parliamentary Under-Secretary of State at the Department for International Development",
	"Parliamentary Under-Secretary of State at the Department for the Environment, Food and Rural Affairs",
	"Parliamentary Under-Secretary of State at the Foreign Office",
	"Parliamentary Under-Secretary of State at the Foreign and Commonwealth Office",
	"Parliamentary Under-Secretary of State at the Home Department",
	"Parliamentary Under-Secretary of State at the Home Office"
	"Parliamentary Under-Secretary of State for Defence",
	"Parliamentary Under-Secretary of State for Defence and Minister for Veterans",
	"Parliamentary Under-Secretary of State for Employment Relations, Competition and Consumers",
	"Parliamentary Under-Secretary of State for Environment, Food and Rural Affairs",
	"Parliamentary Under-Secretary of State for Foreign and Commonwealth Affairs",
	"Parliamentary Under-Secretary of State for Health",
	"Parliamentary Under-Secretary of State for Public Health",
	"Parliamentary Under-Secretary of State for Work and Pensions",
	"Parliamentary Under-Secretary of State for the Department for Constitutional Affairs",
	"Parliamentary Under-Secretary of State for the Foreign and Commonwealth Office",
	"Parliamentary Under-Secretary of State for the Home Office",
	"Parliamentary Under-Secretary of State",
	"Parliamentary Under Secretary, the Office of the Deputy Prime Minister",
	"Parliamentary Under Secretary of State",
	"Parliamentary Under-Secretary",
	"Under-Secretary of State for Defence",
	"Under-Secretary of State for Environment, Food and Rural Affairs",
	"Secretary of State for Constitutional Affairs",
	"Secretary of State for Culture, Media and Sport",
	"Secretary of State for Defence",
	"Secretary of State for Education and Skills",
	"Secretary of State for Education",
	"Secretary of State for Foreign and Commonwealth Affairs",
	"Secretary of State for Health",
	"Secretary of State for International Development",
	"Secretary of State for Northern Ireland",
	"Secretary of State for Scotland",
 	"Secretary of State for Trade and Industry",
	"Secretary of State for Transport",
	"Secretary of State for Work and Pensions",
	"Secretary of State for the Environment, Food and Rural Affairs",
	"Secretary of State for the Foreign and Commonwealth Office",
	"Secretary of State for the Home Department",
 	"Secretary of State",
		]

	majorheadings = {
		"ADVOCATE-GENERAL":"ADVOCATE-GENERAL",
			"ADVOCATE GENERAL":"ADVOCATE-GENERAL",
		"ADVOCATE-GENERAL FOR SCOTLAND":"ADVOCATE-GENERAL FOR SCOTLAND",
		"AGRICULTURE, FISHERIES AND FOOD":"AGRICULTURE, FISHERIES AND FOOD",
		"ATTORNEY-GENERAL":"ATTORNEY-GENERAL",
		"CABINET OFFICE":"CABINET OFFICE",
			"CABINET":"CABINET OFFICE",
		"CULTURE MEDIA AND SPORT":"CULTURE MEDIA AND SPORT",
			"CULTURE, MEDIA AND SPORT":"CULTURE MEDIA AND SPORT",
			"CULTURE, MEDIA AND SPORTA":"CULTURE MEDIA AND SPORT",
			"CULTURE, MEDIA, SPORT":"CULTURE MEDIA AND SPORT",
		"CHURCH COMMISSIONERS":"CHURCH COMMISSIONERS",
                        "CHURCH COMMISSIONER":"CHURCH COMMISSIONERS",
		"CONSTITUTIONAL AFFAIRS":"CONSTITUTIONAL AFFAIRS",
                        "CONSTITIONAL AFFAIRS":"CONSTITUTIONAL AFFAIRS",
		"DEFENCE":"DEFENCE",
		"DEPUTY PRIME MINISTER":"DEPUTY PRIME MINISTER",
		"DUCHY OF LANCASTER":"DUCHY OF LANCASTER",
		"EDUCATION AND EMPLOYMENT":"EDUCATION AND EMPLOYMENT",
		"ENVIRONMENT FOOD AND RURAL AFFAIRS":"ENVIRONMENT FOOD AND RURAL AFFAIRS",
			"ENVIRONMENT, FOOD AND RURAL AFFAIRS":"ENVIRONMENT FOOD AND RURAL AFFAIRS",
			"DEFRA":"ENVIRONMENT, FOOD AND RURAL AFFAIRS",
		"ENVIRONMENT, FOOD AND THE REGIONS":"ENVIRONMENT, FOOD AND THE REGIONS",
		"ENVIRONMENT":"ENVIRONMENT",
		"EDUCATION AND SKILLS":"EDUCATION AND SKILLS",
		"EDUCATION":"EDUCATION",
		"ELECTORAL COMMISSION COMMITTEE":"ELECTORAL COMMISSION COMMITTEE",
			"ELECTORAL COMMISSION":"ELECTORAL COMMISSION COMMITTEE",
		"FOREIGN AND COMMONWEALTH AFFAIRS":"FOREIGN AND COMMONWEALTH AFFAIRS",
			"FOREIGN AND COMMONWEALTH":"FOREIGN AND COMMONWEALTH AFFAIRS",
			"FOREIGN AND COMMONWEALTH OFFICE":"FOREIGN AND COMMONWEALTH AFFAIRS",
		"HOME DEPARTMENT":"HOME DEPARTMENT",
			"HOME OFFICE":"HOME DEPARTMENT",
			"HOME":"HOME DEPARTMENT",
		"HEALTH":"HEALTH",
		"HOUSE OF COMMONS":"HOUSE OF COMMONS",
		"HOUSE OF COMMONS COMMISSION":"HOUSE OF COMMONS COMMISSION",
			"HOUSE OF COMMMONS COMMISSION":"HOUSE OF COMMONS COMMISSION",
		"INTERNATIONAL DEVELOPMENT":"INTERNATIONAL DEVELOPMENT",
			"INTERNATIONAL DEVELOPENT":"INTERNATIONAL DEVELOPMENT",
                        "INTERNATIONAL DEVEOPMENT":"INTERNATIONAL DEVELOPMENT",
		"LEADER OF THE HOUSE":"LEADER OF THE HOUSE",
		"LEADER OF THE COUNCIL":"LEADER OF THE COUNCIL",
		"LORD CHANCELLOR":"LORD CHANCELLOR",
			"LORD CHANCELLOR'S DEPARTMENT":"LORD CHANCELLOR",
			"LORD CHANCELLORS DEPARTMENT":"LORD CHANCELLOR",
			"LORD CHANCELLOR'S DEPT":"LORD CHANCELLOR",
		"LORD PRESIDENT OF THE COUNCIL":"LORD PRESIDENT OF THE COUNCIL",
		"MINISTER FOR WOMEN":"MINISTER FOR WOMEN",
		"NATIONAL HERITAGE":"NATIONAL HERITAGE",
		"NORTHERN IRELAND":"NORTHERN IRELAND",
		"OVERSEAS DEVELOPMENT ADMINISTRATION":"OVERSEAS DEVELOPMENT ADMINISTRATION",
		"PRIME MINISTER":"PRIME MINISTER",
		"PRIVY COUNCIL":"PRIVY COUNCIL",
			"PRIVY COUNCIL OFFICE":"PRIVY COUNCIL",
		"PRESIDENT OF THE COUNCIL":"PRESIDENT OF THE COUNCIL",
		"PUBLIC ACCOUNTS COMMISSION":"PUBLIC ACCOUNTS COMMISSION",
		"SOLICITOR-GENERAL":"SOLICITOR-GENERAL",
			"SOLICITOR GENERAL":"SOLICITOR-GENERAL",
		"SCOTLAND":"SCOTLAND",
		"SOCIAL SECURITY":"SOCIAL SECURITY",
		"TRANSPORT":"TRANSPORT",
		"TRANSPORT, LOCAL GOVERNMENT AND THE REGIONS":"TRANSPORT, LOCAL GOVERNMENT AND THE REGIONS",
		"TRADE AND INDUSTRY":"TRADE AND INDUSTRY",
		"TREASURY":"TREASURY",
		"WALES":"WALES",
		"WORK AND PENSIONS":"WORK AND PENSIONS",
			}
        
	daysofweek = 'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday'
	monthsofyear = 'January|February|March|April|May|June|July|August|September|October|November|December'
	datephrase = '((?:%s )?((?:\d+ )?(?:%s)(?: \d+)?))' % (daysofweek, monthsofyear)
	redatephrase = re.compile(datephrase)


	# make a huge regexp
	def __init__(self):
		sio = None
		for j in self.jobs:
			if sio:
				sio.write('|')
			else:
				sio = cStringIO.StringIO()
			sio.write(j)

		self.regexpjobs = sio.getvalue()
		sio.close()


parlPhrases = ParlPhrases()
