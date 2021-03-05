import random, sequtils

import nico


type
  CeilBlock = object
    spriteId: int

  FloorBlock = object
    slot: bool
    x, y: int
    spriteId: int

  Gun = object
    x: int
    spriteId: int

  Bullet = object
    x, y: int
    spriteId: int


const
  spriteSize = 16
  gameWidth = 10
  gameHeight = 10
  floorTimer = 1
  bulletSpeed = 10

var
  ceiling: seq[CeilBlock]
  floor: seq[FloorBlock]
  gun: Gun
  bullets: seq[Bullet]
  score: int
  floorPause = 0.0
  hit: bool
  finished: bool


proc gameInit() =
  loadFont(0, "font.png")

  loadSpritesheet(0, "spritesheet.png", spriteSize, spriteSize)

  loadSfx(0, "shoot.ogg")
  loadSfx(1, "hit.ogg")

  for _ in 1..gameWidth:
    ceiling.add CeilBlock(spriteId: 0)

  gun = Gun(x: (spriteSize * gameWidth) div 2, spriteId: 1)

proc gameUpdate(dt: float32) =
  if floorPause > 0:
    floorPause -= dt

  for b in bullets.mitems:
    b.y += bulletSpeed

  bullets.keepItIf(it.y < spriteSize * gameHeight)

  if btnpr(pcLeft, repeat = 5):
    if gun.x > 0:
      gun.x -= spriteSize

  if btnpr(pcRight, repeat = 5):
    if gun.x < spriteSize * (gameWidth - 1):
      gun.x += spriteSize

  if btnpr(pcA, repeat = 20):
    sfx(0, 0)
    bullets.add Bullet(x: gun.x, y: spriteSize, spriteId: 2)

  if floorPause <= 0:
    let storeCount = len(floor) div gameWidth

    if storeCount >= gameHeight - 2:
      finished = true

    let slotNum = rand(gameWidth - 1)

    for i in 0..<gameWidth:
      let
        slot = i == slotNum
        y = spriteSize * gameHeight - spriteSize * (storeCount + 1)

      floor.add FloorBlock(slot: slot, x: i * spriteSize, y: y, spriteId: if slot: 3 else: 4)

    floorPause = floorTimer

  if len(floor) > 0:
    for f in floor[^gameWidth..^1].filterIt(it.slot):
      for b in bullets:
        if b.x == f.x and b.y >= f.y and b.y <= f.y + spriteSize:
          hit = true

  if hit:
    sfx(0, 1)
    floor.delete(len(floor) - gameWidth, high(floor))
    hit = false
    inc score

  if finished:
    if btnp(pcStart):
      finished = false
      gun.x = (spriteSize * gameWidth) div 2
      floor.setLen(0)
    if btnp(pcB):
      shutdown()

proc gameDraw() =
  cls()

  setColor(7)
  boxFill(0, 0, screenWidth, screenHeight)

  if finished:
    sprs(2, 0, 0, 1, 1, 8, 8)

    setColor(2)
    printc("I love you!", screenWidth div 2, screenHeight div 2 - spriteSize)

    setColor(0)
    print("Score: " & $score, screenWidth div 4, screenHeight div 2)
    print("Press Enter to play again", screenWidth div 4, screenHeight div 2 + spriteSize)
    print("Press X to exit", screenWidth div 4, screenHeight div 2 + spriteSize * 2)

  else:
    for i, c in ceiling:
      spr(c.spriteId, spriteSize * i, 0)

    spr(gun.spriteId, gun.x, 0)

    for b in bullets:
      spr(b.spriteId, b.x, b.y)

    for f in floor:
      spr(f.spriteId, f.x, f.y)

    setColor(0)
    print($score, 0, 0)

randomize()

nico.init("moigagoo", "Love Gun")
nico.createWindow("Love Gun", gameWidth * spriteSize, gameHeight * spriteSize, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
