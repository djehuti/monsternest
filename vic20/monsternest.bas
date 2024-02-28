1 print"{clr}{red}{10 down}     monsternest"
2 print"     1983 * cox"
3 poke36879,24
4 fort=1to1350:nextt
5 poke56,28:poke52,28:clr:a=7910
10 form=0to65:readn:poke7168+m,n:next
20 data169,128,141,19,145,169,0,133,1,133,2,169,127,141,34,145,162,119,236,32,145
30 data208,4,169,1,133,1,169,255,141,34,145,162,118,236,17,145,208,4,169,22,133,1
40 data162,110,236,17,145,208,4,169,1,133,2,162,122,236,17,145,208,4,169,22,133,2,96
41 print"{clr}{grn}skill level?"
42 getsl$:ifsl$=""then42
43 ifval(sl$)=1thensr=11:goto50
44 ifval(sl$)=2thensr=9:goto50
46 ifval(sl$)=3thensr=7:goto50
47 goto42
50 print "{clr}":forx=38400to38905:pokex,0:nextx
60 forx=1to75:y=int(rnd(1)*500)+7680:pokey,87:next
70 pokea,42:sys7168:b=a+peek(1)-peek(2)
80 ifb>8185orb<7680orpeek(b)=87orpeek(b)=94orpeek(b)=86thengosub30000
85 print"{home}{red}score:";ys;"{left}/skill:";val(sl$)
86 ifp=0thenprint"***  "
87 ifp=1thenprint"**   "
88 ifp=2thenprint"*    "
90 pokea,32:a=b:ifpeek(37137)>100then70
100 gosub15000
110 goto70
15000 poke36878,15:poke36877,225
15010 fort=1to50:nextt:poke36877,0
15015 ifpeek(37137)=94then15100
15016 ifpeek(37137)=86then15200
15017 ifpeek(37137)=78then15300
15018 ifpeek(37137)=90then15400
15020 poke36878,v:fort=1to50
15030 return
15100 fors=1tosr
15110 sp=a+s:ifpeek(sp)=87then20000
15120 nexts:poke36877,0
15130 return
15200 fors=22to(sr*22)step22
15210 sp=a+s:ifpeek(sp)=87then20000
15220 nexts:poke36877,0
15230 return
15300 fors=1tosr
15310 sp=a-s:ifpeek(sp)=87then20000
15320 nexts:poke36877,0
15330 return
15400 fors=22to(sr*22)step22
15410 sp=a-s:ifpeek(sp)=87then20000
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
63990 print"{clr}{pur}your score was";ys;"!"
