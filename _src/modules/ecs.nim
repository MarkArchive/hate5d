# häte5d-engine/_src/module/ecs.nim
# +=========================================+
# | copyright (c) 2026 MarkArchive/devdeco  |
# | License: LGPL 3.0                       |
# +=========================================+
# o ecs.nim funcionará como um ecs comum mesmo
# ele vai "simplificar" e ajudar o programador com abstrações
import ../core/[common, sdl2]
import options, random, tables

randomize()

type
    Tag* = ref object of RootObj
        desc*   : string
        label*  : string

    Group* = ref object of RootObj
        name*   : string
        desc*   : string
        tags*   : Option[seq[Tag]]      # Tags que entram no group
        groups* : Option[seq[Group]]    # Groups relacionados a esse group

    # um Concept é uma descrição de algum sistema
    # ele pode representar mana, inventário, diálogo,
    # facções ou qualquer outro sistema do jogo
    Concept* = ref object of RootObj
        cid*    : int64     # concept ID
        desc*   : Option[string]

    # um Thing é uma abstração do Object
    # ele existe no mundo mas não possui lógica própria
    # herda de Object para usar drawObject/deleteObject diretamente
    Thing* = ref object of Object
        concepts*   : seq[Concept]
        reaction*   : seq[proc(self: Thing)]
        tags*       : seq[Tag]
        group*      : seq[string]
    
    # uma Entity é um Thing que possui lógica
    Entity* = ref object of Thing
        logic*  : seq[proc(self: Entity)]

var
    groupTable*: Table[string, Group]
    tagTable*: Table[string, Tag]
    objectTable*: Table[int64, Object]

    thingRegistry*: seq[Thing]
    entityRegistry*: seq[Entity]

# cria um Thing com mais estrutura
# caso tenha notado, alguns campos estão vazios
# isso é de proposito pra você preencher ;) (seu preguiçoso)
proc createThing*(
    name: string, 
    tipo: ObjectType, 
    x, y, w, h: int32,
    img: Option[string],
    tex: SdlTexture,
): Thing =
    var thing = Thing(
        id      : rand(int32(20000)) - 10000,
        name    : name,
        tipo    : tipo,
        x       : x,
        y       : y,
        w       : w,
        h       : h,
        visible : true,
        img     : none(string),
        tex     : nil,
        concepts: @[],
        reaction: @[],
        tags    : @[],
        group   : @[]
    )

    objectTable.add(thing.id, thing)

    return thing

# o deleteThing serve mais para apagar no registro
# é recomendado usar o deleteObject para apagar da janela
proc deleteThing*(thing: Thing) =
    let pos = thingRegistry.find(thing)

    if pos >= 0:
        thingRegistry.delete(pos)

    objectTable.del(thing.id)

# execução
proc react*(thing: Thing) =
    for r in thing.reaction:
        r(thing)

proc update*(entity: Entity) =
    for logic in entity.logic:
        logic(entity)

proc updateAllEntities*() =
    for entity in entityRegistry:
        update(entity)

# tags
proc createTag*(label, desc: string): Tag =
    let tag = Tag(
        label: label,
        desc: desc
    )

    tagTable[label] = tag
    return tag

proc addTag*(thing: Thing, tag: Tag) =
    thing.tags.add(tag)

proc findTag*(label: string): Option[Tag] =
    if tagTable.hasKey(label):
        return some(tagTable[label])

    return none(Tag)

# groups
proc createGroup*(name, desc: string): Group =
    let group = Group(
        name    : name,
        desc    : desc,
        tags    : none(seq[Tag]),
        groups  : none(seq[Group])
    )

    groupTable[name] = group
    return group

proc addGroup*(thing: Thing, group: string) =
    thing.group.add(group)

proc findGroup*(name: string): seq[Thing] =
    for thing in thingRegistry:
        if name in thing.group:
            result.add(thing)

proc findThingsByTag*(label: string): seq[Thing] =
    for thing in thingRegistry:
        for tag in thing.tags:
            if tag.label == label:
                result.add(thing)
                break

# modf_*: modifica parâmetros de alguns tipos internos
# o modf tem 3 variações:
#   madd: adiciona algo
#   rmov: remove algo
#   modf: modifica algo no geral (tipo configWindow)

# concept
proc madd_concept*(entity_thing: Thing, concep: Concept) =
    entity_thing.concepts.add(concep)

proc rmov_concept*(entity_thing: Thing, concep: Concept) =
    let pos = entity_thing.concepts.find(concep)
    if pos >= 0: entity_thing.concepts.delete(pos)

proc modf_concept*(entity_thing: Thing, concep: Concept, op: string): HateResult[bool] =
    case op
    of "madd": madd_concept(entity_thing, concep)
    of "rmov": rmov_concept(entity_thing, concep)
    else: return fail("unkown opcode", false)

    return ok(true)

# logic
proc madd_logic*(entity: Entity, logic: proc(self: Entity)) =
    entity.logic.add(logic)

proc rmov_logic*(entity: Entity, logic: proc(self: Entity)) =
    let pos = entity.logic.find(logic)
    if pos >= 0: entity.logic.delete(pos)

proc modf_logic*(entity: Entity, logic: proc(self: Entity), op: string): HateResult[bool] =
    case op
    of "madd": madd_logic(entity, logic)
    of "rmov": rmov_logic(entity, logic)
    else: return fail("unkown opcode", false)

    return ok(true)

# reaction
proc madd_reaction*(entity_thing: Thing, react: proc(self: Thing)) =
    entity_thing.reaction.add(react)

proc rmov_react*(entity_thing: Thing, react: proc(self: Thing)) =
    let pos = entity_thing.reaction.find(react)
    if pos >= 0: entity_thing.reaction.delete(pos)

proc modf_reaction*(entity_thing: Thing, react: proc(self: Thing), op: string): HateResult[bool] =
    case op
    of "madd": madd_reaction(entity_thing, react)
    of "rmov": rmov_react(entity_thing, react)
    else: return fail("unkown opcode", false)

    return ok(true)