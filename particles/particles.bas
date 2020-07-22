SCREEN _NEWIMAGE(800, 600, 32)

RANDOMIZE TIMER

TYPE object
    x AS SINGLE
    y AS SINGLE
    xv AS SINGLE
    yv AS SINGLE
    state AS _BYTE
    size AS INTEGER
END TYPE

DIM SHARED o(500) AS object

'generate individuals
FOR i = 1 TO UBOUND(o)
    o(i).x = RND * _WIDTH
    o(i).y = RND * _HEIGHT
    o(i).xv = 1 - RND * 2
    o(i).yv = 1 - RND * 2
    o(i).state = 1 'healthy
    o(i).size = 10
NEXT

infected = _CEIL(RND * UBOUND(o))
o(infected).state = 2 'infected

DIM c(1 TO 2) AS _UNSIGNED LONG
c(1) = _RGB32(11, 255, 0)
c(2) = _RGB32(200, 67, 17)

DO
    CLS
    FOR i = 1 TO UBOUND(o)
        move o(i)
        IF o(i).state = 2 THEN spread o(i)
        CircleFill o(i).x, o(i).y, o(i).size, c(o(i).state)
    NEXT

    _DISPLAY
    _LIMIT 120
LOOP
SYSTEM

SUB spread (obj AS object)
    FOR i = 1 TO UBOUND(o)
        IF dist(obj, o(i)) < obj.size * 2 THEN
            o(i).state = 2
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

SUB move (obj AS object)
    obj.x = obj.x + obj.xv
    IF obj.x < 0 OR obj.x > _WIDTH THEN obj.xv = obj.xv * -1

    obj.y = obj.y + obj.yv
    IF obj.y < 0 OR obj.y > _HEIGHT THEN obj.yv = obj.yv * -1
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

