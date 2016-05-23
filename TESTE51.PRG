
LStime = SUBS(STRTRAN(Time(),":",""),3)
LSusr  = subs(STRTRAN(str(nUsr,4)," ","0"),3)


LSnomearq = LStime+LSusr+CHR(LNtmp)

