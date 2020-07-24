SCREEN _NEWIMAGE(800, 600, 32)

RANDOMIZE TIMER

TYPE object
    x AS SINGLE
    y AS SINGLE
    xv AS SINGLE
    yv AS SINGLE
    size AS INTEGER
    c AS _UNSIGNED LONG
END TYPE

DIM SHARED o(130) AS object
DIM SHARED i AS INTEGER

'initialize array
FOR i = 1 TO UBOUND(o)
    o(i).x = RND * _WIDTH
    o(i).y = RND * _HEIGHT
    o(i).xv = 1 - RND * 2
    o(i).yv = 1 - RND * 2
    o(i).size = 10
    o(i).c = _RGB32(RND * 255, RND * 255, RND * 255, 100)
NEXT

DIM SHARED minDistance AS INTEGER
minDistance = 50

DO
    WHILE _MOUSEINPUT: WEND
    mx = _MOUSEX

    minDistance = map(mx, 0, _WIDTH, 0, 200)

    CLS

    LINE (0, _HEIGHT - 20)-(mx, _HEIGHT), _RGB32(255, 50), BF

    FOR i = 1 TO UBOUND(o)
        move o(i)
        connect o(i)
        CircleFill o(i).x, o(i).y, o(i).size, o(i).c
    NEXT

    _DISPLAY
    _LIMIT 60
LOOP UNTIL _KEYHIT = 27
SYSTEM

FUNCTION map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION

SUB connect (this AS object)
    DIM j AS INTEGER
    FOR j = 1 TO UBOUND(o)
        IF dist(o(j), this) <= minDistance THEN
            LINE (this.x, this.y)-(o(j).x, o(j).y), this.c
        END IF
    NEXT
END SUB

FUNCTION dist! (o1 AS object, o2 AS object)
    x1! = o1.x
    y1! = o1.y
    x2! = o2.x
    y2! = o2.y
    dist! = _HYPOT((x2! - x1!), (y2! - y1!))
END FUNCTION

SUB move (this AS object)
    this.x = this.x + this.xv
    IF this.x < 0 OR this.x > _WIDTH THEN this.xv = this.xv * -1

    this.y = this.y + this.yv
    IF this.y < 0 OR this.y > _HEIGHT THEN this.yv = this.yv * -1
END SUB


SUB CircleFill (CX AS INTEGER, CY AS INTEGER, R AS INTEGER, C AS _UNSIGNED LONG)
    ' CX = center x coordinate
    ' CY = center y coordinate
    '  R = radius
    '  C = fill color
    DIM Radius AS INTEGER, RadiusError AS INTEGER
    DIM X AS INTEGER, Y AS INTEGER
    Radius = ABS(R)
    RadiusError = -Radius
    X = Radius
    Y = 0
    IF Radius = 0 THEN PSET (CX, CY), C: EXIT SUB
    LINE (CX - X, CY)-(CX + X, CY), C, BF
    WHILE X > Y
        RadiusError = RadiusError + Y * 2 + 1
        IF RadiusError >= 0 THEN
            IF X <> Y + 1 THEN
                LINE (CX - Y, CY - X)-(CX + Y, CY - X), C, BF
                LINE (CX - Y, CY + X)-(CX + Y, CY + X), C, BF
            END IF
            X = X - 1
            RadiusError = RadiusError - X * 2
        END IF
        Y = Y + 1
        LINE (CX - X, CY - Y)-(CX + X, CY - Y), C, BF
        LINE (CX - X, CY + Y)-(CX + X, CY + Y), C, BF
    WEND
END SUB

