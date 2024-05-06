1 print"{clr}{red}{10 down}     monsternest"
2 print"     1983 * cox"
3 poke36879,24
4 fort=1to1350:nextt
5 poke56,28:poke52,28:clr:a=7910
10 form=0to77:readn:poke7168+m,n:next
20 data169,0,133,1,133,2,173,34,145,168,41,127,141,34,145,173,19,145,41,195,141,19
21 data145,173,32,145,41,128,208,7,169,1,133,1,76,73,28,173,17,145,170,41,8,208,7,169
22 data22,133,1,76,73,28,138,41,16,208,7,169,1,133,2,76,73,28,138,41,4,208,4,169,22
23 data133,2,152,141,34,145,96
30 print"{clr}{grn}skill level?"
35 getsl$:ifsl$=""then35
40 ifval(sl$)=1thensr=11:goto50
41 ifval(sl$)=2thensr=9:goto50
42 ifval(sl$)=3thensr=7:goto50
43 goto35
50 print "{clr}":forx=38400to38905:pokex,0:nextx
60 forx=1to75:y=int(rnd(1)*500)+7680:pokey,87:next
70 pokea,42:sys7168:jr=peek(1):jo=peek(2)
71 fb=peek(37137)and32:iffb=0then100
80 b=a+jr-jo:ifb>8185orb<7680orpeek(b)=87orpeek(b)=94orpeek(b)=86thengosub30000
85 print"{home}{red}score:";ys;"{left}/skill:";val(sl$)
86 ifp=0thenprint"***  "
87 ifp=1thenprint"**   "
88 ifp=2thenprint"*    "
90 pokea,32:a=b:goto70
100 gosub15000
110 goto70
15000 poke36878,15:poke36877,225
15010 fort=1to50:nextt:poke36877,0
15014 jv=peek(37137)and28
15015 ifjr=1andjv=28then15100
15016 ifjv=20then15200
15017 ifjv=12then15300
15018 ifjv=24then15400
15020 poke36878,v:fort=1to50:nextt
15030 return
15100 fors=1tosr : rem shoot right
15110 sp=a+s:ifpeek(sp)=87then20000
15111 qz=peek(sp)
15112 pokesp,46:fort=1to10:nextt:pokesp,qz
15120 nexts:poke36877,0
15130 return
15200 fors=22to(sr*22)step22 : rem shoot down
15210 sp=a+s:ifpeek(sp)=87then20000
15211 qz=peek(sp)
15212 pokesp,46:fort=1to10:nextt:pokesp,qz
15220 nexts:poke36877,0
15230 return
15300 fors=1tosr : rem shoot left
15310 sp=a-s:ifpeek(sp)=87then20000 : rem shoot left
15311 qz=peek(sp)
15312 pokesp,46:fort=1to10:nextt:pokesp,qz
15320 nexts:poke36877,0
15330 return
15400 fors=22to(sr*22)step22 : rem shoot up
15410 sp=a-s:ifpeek(sp)=87then20000
15411 qz=peek(sp)
15412 pokesp,46:fort=1to10:nextt:pokesp,qz
15420 nexts:poke36877,0
15430 return
20000 remmonster death
20010 poke36878,15:poke36877,130
20015 mw=(int(rnd(1)*20)+1):pokesp+30720,0
20020 pokesp,94
20030 form=1to50:nextm:ifmw<15thenpokesp,32
20032 poke36877,0
20035 ys=ys+10:ifys=600orys=1200orys=1800orys=2400orys=3000then50
20036 ifys=3600thenprint"{clr}{7 right}{10 down}{blk}y{red}o{cyn}u {pur}w{grn}o{blu}n{yel}!":fort=1to1350:nextt:goto63990
20037 ifmw>14then50000
20040 return
30000 remplayer death
30004 ifpeek(b)=94orpeek(b)=86orpeek(a)=94orpeek(a)=86thentm=1
30005 forf=1to20
30010 poke36878,15:poke36877,250:poke36875,250
30020 pokea,32
30030 forw=1to10:nextw:pokea,102
30040 poke36877,0:poke36875,0:forw=1to10:nextw
30050 nextf
30052 p=p+1:ifp=3then63990
30053 iftm=1then63990
30060 return
50000 rem*ichor sq*
50010 pokea,42:bd=int(rnd(1)*4)
50020 ifbd=0thenpb=-22
50030 ifbd=1thenpb=1
50040 ifbd=2thenpb=22
50050 ifbd=3thenpb=-1
50060 forqb=(sp+pb)to(sp+(6*pb))steppb
50070 ifpeek(qb)=87thensp=qb:ifpeek(qb)=87thengosub20000
50080 poke(qb+30720),2
50085 ifqb=athentm=1:ifqb=athen30000
50086 pokeqb,86
50090 nextqb
50100 return
55000 print"{blu}{clr}":poke36879,238
55001 end
63990 print"{clr}{pur}your score was";ys;"!"
