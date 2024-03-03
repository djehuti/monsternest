1 poke53281,1:poke53280,6:print"{clr}{red}{8 down}{swuc}{dish}              monsternest"
2 print"{pur}{down}              1983 ** cox":rempoke788,52
3 print"{cyan}{down}             instructions?"
4 print"{cyan}             {13 $a3}"
5 print"{yel}               (y or n)"
6 print"{red}";:getyn$:ifyn$<>"y"andyn$<>"n"then6
7 ifyn$="y"thengosub1000
30 print"{clr}skill level (1-3)? {$a4}{left}";
41 getsl$:ifsl$<"1"orsl$>"3"then41
42 sr=27-(5*val(sl$)+2*val(sl$))
43 printsl$;"{$a4}"
44 fort=1to350:next:print"{clr}"
50 fort=55296to56295:poket,0:next
60 fort=1to150
61 l=int(rnd(1)*920)+1104:ifpeek(l)<>32orl=1444then61
62 pokel,87:nextt:x=20:y=10
69 print "{home}{red}   * * * m o n s t e r n e s t * * *"
70 poke1024+x+40*y,42
71 j=peek(56320):n=jand1:s=jand2:w=jand4:e=jand8:f=jand16
72 iff=0then80
73 x1=x+(w=0)-(e=0):y1=y+(n=0)-(s=0):poke1024+x+40*y,32
74 ifx1<0orx1>39ory1>24orpeek(1024+x1+40*y1)=87thengosub31000:x=20:y=10:goto85
75 ifpeek(1024+x1+40*y1)<>32thenp=2:gosub31000
76 ify1<2theny1=2
77 x=x1:y=y1:goto85
80 gosub15000
85 print"{home}{down}";:gosub40000
87 print"{home}{down}"tab(19)" score:"sc"{left}  "
88 ifs1>100thens1=0:goto44
89 goto70
1000 print"{clr}{pur}you are the * in the middle of the"
1001 print"{down}{yel}screen.  you move around the screen by"
1002 print"{down}{grn}pushing the joystick in the direction"
1003 print"{down}{blue}you want to go.  you must destroy {rvon}100{rvof}{up}{3 left}{3 $a4}{down}"
1004 print"{down}{orng}of the eggs (W) of the dragon by pushing"
1005 print"{red}the fire button and then pushing the "
1006 print"{down}{lblu}joystick in the direction of the egg."
1007 print"{down}{lred}it will either die or hatch(!)"
1008 print"{down}{pur}if it hatches, it will shoot a stream of{red}{15 $a4}"
1009 print"{red}{rvon}poisonous blood{rvof} in a random direction."
1010 print"{4 down}{cyan}{rvon}       hit  'space'  to continue       {home}"
1011 getyn$:ifyn$<>" "then1011
1012 print"{clr}{red}if you touch this {rvon}poisonous blood{rvof}, or"
1013 print"{down}{pur}a hatched baby dragon, the game will"
1014 print"{down}{blue}end.  if you touch an egg or go off the"
1015 print"{down}{grn}screen, you will lose one life (you get"
1016 print"{down}{yel}three).  if you shoot {rvon}100{rvof}{up}{3 left}{3 $a4}{down} of the eggs,"
1017 print"{down}{orng}a new screenfull will appear."
1018 print"{down}{red}   good  luck."
1019 print"{home}{23 down}  h i t   s p a c e   t o   s t a r t{home}"
1020 getyn$:ifyn$<>" "then1020
1021 return
15000 xd=0:yd=0:ifw=0thenxd=-1:goto15010
15001 ife=0thenxd=1:goto15010
15002 ifn=0thenyd=-1:goto15010
15003 ifs=0thenyd=1:goto15010
15004 return
15010 for t=1tosr
15013 ifx+xd*t<0orx+xd*t>39thenreturn
15014 ify+yd*t<2ory+yd*t>24thenreturn
15015 sl=1024+x+xd*t+40*(y+yd*t):q=peek(sl):pokesl,46
15020 ifq=87thenfort1=1to9:poke54296,15:poke54296,0:nextt1
15021 ifq=87thengosub20000:return
15022 pokesl,q:nextt:return
20000 sc=sc+10:s1=s1+1:pokesl,32:poke1024+x+40*y,42:ifsw=1thensw=0:goto20002
20001 ifrnd(1)<.55thenreturn
20002 pokesl,94:pokesl+54272,5:sl=sl-1024:sx=sl-(int(sl/40)*40):sy=int((sl-sx)/40)
20003 xd=0:yd=0:xd=int(rnd(1)*3)-1:ifxd<>0then20005
20004 yd=int(rnd(1)*3)-1:ifyd=0then20003
20005 fort=1to5
20006 if(sx+xd*t<0)or(sx+xd*t>39)or(sy+yd*t<2)or(sy+yd*t>24)thenreturn
20007 ifpeek(1024+sx+xd*t+(yd*t+sy)*40)=42thenp=2:gosub31000:return
20010 sl=1024+sx+xd*t+(yd*t+sy)*40
20011 ifpeek(sl)=87thenfort=1to9:poke54296,15:poke54296,0:next:sw=1:goto20000
20012 pokesl,86:pokesl+54272,2:next:return
30000 p=p+1:ifp=3then60000
30001 return
31000 fort=1to9:poke54296,15:poke54296,0:nextt:goto30000
40000 ifp=0thenprint"***":return
40001 ifp=1thenprint"** ":return
40002 ifp=2thenprint"*  ":return
40003 print"   ":return
60000 print"{clr}you got killed 3 times and had a score"
60001 print"of";sc;"{left}."
60003 print"to play again, type the space bar.  to  quit, type q."
60004 getyn$:ifyn$<>" "andyn$<>"q"then60004
60005 ifyn$=" "thenrun
60006 poke788,49:end
