DECLARE SUB bmper ()
DECLARE SUB delay (seconds!)
RANDOMIZE TIMER
CONST del = .02         'Sets standard movement delay (.02)
CONST scrnmode = 13     'Sets SCREEN mode (12 or 13)
CONST lowerbound = 100  'Least amount of sparks to create (100)
CONST upperbound = 200  'Greatest amount of sparks to create (200)
CONST sparkdelay = 0    'If 1 then firework explosion is subject to delay (0)
CONST launchtime = 25   'How long projectile lasts before exploding (25)
CONST delete = 0        'If 1 then trail is erased (0)
IF scrnmode <> 12 AND scrnmode <> 13 THEN
PRINT "Scrnmode must be 12 or 13!"
END
END IF

SCREEN scrnmode
IF scrnmode = 13 THEN
xmax = 320
ymax = 200
ELSE
xmax = 640
ymax = 480
END IF


DO
IF scrnmode = 13 THEN
col = INT(RND * 255) + 1
ELSE
col = INT(RND * 15) + 1
END IF

a = RND * xmax
B = ymax

G = INT(RND * (upperbound - lowerbound)) + lowerbound
REDIM l1(1 TO G)
REDIM l2(1 TO G)
REDIM l3(1 TO G)
REDIM l4(1 TO G)



PSET (a, B), col
IF delete = 1 THEN LINE (a - ainc - ainc, B - binc - (binc - 1.2))-(a - ainc, B - binc), 0
IF scrnmode = 13 THEN
ainc = RND * 20 - 10
binc = RND * -10 - 5
ELSE
ainc = RND * 40 - 20
binc = RND * -24 - 12
END IF

FOR c = 1 TO launchtime

IF scrnmode = 13 THEN
binc = binc + .5
ELSE
binc = binc + 1.2
END IF

a = a + ainc
B = B + binc
IF a < 0 THEN
a = 0
ainc = -ainc
END IF
IF a > xmax THEN
a = xmax
ainc = -ainc
END IF
IF B < 0 THEN
B = 0
binc = -binc
END IF
IF B > ymax THEN
B = ymax
binc = -binc
END IF
LINE -(a, B), col
delay del
NEXT

FOR c = 1 TO G
l1(c) = a
l2(c) = B
IF scrnmode = 13 THEN
l3(c) = RND * 5 - 2.5
l4(c) = RND * -5 + 2.5
ELSE
l3(c) = RND * 10 - 5
l4(c) = RND * -10 + 5
END IF

NEXT
FOR c = 1 TO launchtime
FOR z = 1 TO G
PSET (l1(z), l2(z)), col
IF delete = 1 THEN LINE (l1(z) - l3(z), l2(z) - l4(z))-(l1(z), l2(z)), 0
IF scrnmode = 13 THEN
l4(z) = l4(z) + .1
ELSE
l4(z) = l4(z) + .2
END IF

l1(z) = l1(z) + l3(z)
l2(z) = l2(z) + l4(z)
IF l1(z) < 0 THEN
l1(z) = 0
l3(z) = .5 * -l3(z)
END IF
IF l1(z) > xmax THEN
l1(z) = xmax
l3(z) = .5 * -l3(z)
END IF
IF l2(z) < 0 THEN
l2(z) = 0
l4(z) = .5 * -l4(z)
END IF
IF l2(z) > ymax THEN
l2(z) = ymax
l4(z) = .5 * -l4(z)
END IF
LINE -(l1(z), l2(z)), col
NEXT
IF sparkdelay = 1 THEN delay del
NEXT
LINE (l1(G) - l3(G), l2(G) - l4(G))-(l1(G), l2(G)), 0
'CLS





K$ = INKEY$

IF K$ = CHR$(13) THEN CLS
IF K$ = "+" AND scrnmode = 13 THEN bmper
LOOP

DIM SHARED count
count = 0
SUB bmper
CHDIR "C:\dos"
filename$ = "screen" + RIGHT$("0" + LTRIM$(STR$(count)), 3) + ".bmp"
'PRINT filename$
'RANDOMIZE TIMER
'FOR x = 1 TO 50
'CIRCLE (RND * 320, RND * 200), RND * 50, RND * 155
'NEXT



OPEN filename$ FOR OUTPUT AS #1
'---<General Pic Info)---
PRINT #1, "BM"; 'Tells us is .BMP
PRINT #1, MKL$(65535);  'Size of file
PRINT #1, MKI$(0); 'Reserved1
PRINT #1, MKI$(0); 'Reserved2
PRINT #1, MKL$(1078); 'Num bytes offset picture data
'---<Info Header>---
PRINT #1, MKL$(40); 'Size of info header
PRINT #1, MKL$(320); 'Pic width
PRINT #1, MKL$(200); 'Pic height
PRINT #1, MKI$(1); 'Num planes
PRINT #1, MKI$(8); 'Bits per pixel
PRINT #1, MKL$(0); 'Compression
PRINT #1, MKL$(320 * 200#); 'Image size
PRINT #1, MKL$(3790); 'Pels per meter
PRINT #1, MKL$(3800); 'Pels per meter
PRINT #1, MKL$(0); 'Num colors used (0 means all)
PRINT #1, MKL$(0); 'Num important colors (0 means all)
'---<Palette Data>---
FOR x = 0 TO 255
OUT &H3C7, x
R = INP(&H3C9)
G = INP(&H3C9)
B = INP(&H3C9)
'PRINT R; G; B
PRINT #1, CHR$(B * 4);
PRINT #1, CHR$(G * 4);
PRINT #1, CHR$(R * 4);
PRINT #1, CHR$(0);
NEXT

'---<Picture Data>---
FOR y = 199 TO 0 STEP -1
FOR x = 0 TO 319
PRINT #1, CHR$(POINT(x, y));

NEXT
NEXT
CLOSE 1





count = count + 1
END SUB

SUB delay (seconds!)
start# = TIMER
DO WHILE TIMER - start# < seconds!
LOOP

END SUB
