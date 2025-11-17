#let GROUP_SIZE = 40
// the number of extra blank rows per group
#let EXTRA_ROW_COUNT = 5
#let names = csv("names.csv").flatten()

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2cm),
)

// Set up Arabic font and direction
#set text(
  font: "Arial",
  lang: "ar",
  dir: rtl,
  size: 12pt,
)

#for (group_index, group) in names.chunks(GROUP_SIZE).enumerate(start: 1) [
  #if group_index > 1 [
    #pagebreak()
  ]

  // --- Header Section ---
  #align(center)[
    #underline(
      text(size: 24pt, weight: "bold")[الحضور و الغياب لطلاب المرحلة الخامسة],
    )
  ]

  // --- Info & Group Section ---
  // Using a grid to separate the Group (Left) and Info (Right)
  #grid(
    columns: (1fr, 1fr),
    align: (right, left),
    // Right is start (info), Left is end (Group) in RTL

    // Right side content (Info)
    [
      #set text(weight: "bold")
      اسم المـــــــــادة: \
      #v(5pt)
      عدد الســـــاعات: \
      #v(5pt)
      اسم المحاضر وتوقيعه:
    ],

    // Left side content (Group)
    align(left + horizon)[
      #text(size: 16pt, weight: "bold", dir: ltr)[Group #group_index]
    ],
  )

  #table(
    columns: (auto, auto) + (1fr,) * 10,
    // 1 Index, 1 Name, 10 Checkboxes
    rows: 28pt,
    // Fixed row height
    inset: 5pt,
    align: (col, row) => (
      if col == 1 { center + horizon } else { center + horizon }
    ),
    stroke: 0.7pt + black,

    // Header Color
    fill: (col, row) => if row == 0 { rgb("#5b9bd5") } else { none },

    // Table Header
    table.header(
      [*ت*],
      [*اسم الطالب*],
      table.cell(colspan: 10)[*الحضور و الغياب*],
    ),

    // Table Rows Loop
    ..(group + ("",) * EXTRA_ROW_COUNT)
      .enumerate()
      .map(((name_index, name)) => (
        [#text(weight: "bold")[#(name_index + 1)]], // Number
        align(center)[#text(weight: "medium")[#name]], // Name
        ..range(10).map(_ => ""), // 10 Empty Cells
      ))
      .flatten(),
  )
]
