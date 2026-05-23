// tablet.jsx — iPad-sized screens.
// Sizes used: 1180×820 landscape, 820×600 portrait split (Slide Over)
// All screens use TabletDevice for the bezel.

// ──────────────────────────────────────────────────────────────────
// 1. Tablet Galaxy — full-bleed with right pane (selected property)
// ──────────────────────────────────────────────────────────────────
function TabletGalaxyScreen() {
  const points = layoutFor("roi");
  const selected = PROPERTIES[14];
  const grade = gradeFor(selected);

  return (
    <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Top app bar */}
      <div style={{
        display: "flex", alignItems: "center", padding: "12px 24px",
        background: "var(--surface)", borderBottom: "1px solid var(--line)",
        gap: 16, flexShrink: 0,
      }}>
        <div style={{
          width: 34, height: 34, borderRadius: 10,
          background: "var(--brand-gradient)", color: "#fff",
          display: "flex", alignItems: "center", justifyContent: "center",
        }}>{Ico.galaxy}</div>
        <div style={{ flex: 0 }}>
          <div style={{ fontSize: 18, fontWeight: 700 }}>Tax Lien Galaxy</div>
          <div style={{ fontSize: 11, color: COLORS.fg2 }}>847 properties · 3 states · live</div>
        </div>

        {/* primary nav */}
        <div style={{ marginLeft: 16, display: "flex", gap: 4, padding: 4,
                      background: "var(--bg)", borderRadius: 10, border: "1px solid var(--line)" }}>
          {["Galaxy","Map","Kanban","List","Heatmap","Graph"].map((t,i) => (
            <div key={t} style={{
              padding: "7px 14px", borderRadius: 7, fontSize: 12.5, fontWeight: 600,
              background: i === 0 ? "var(--surface)" : "transparent",
              color: i === 0 ? COLORS.fg1 : COLORS.fg2,
              boxShadow: i === 0 ? "var(--shadow-card)" : "none",
            }}>{t}</div>
          ))}
        </div>

        {/* search */}
        <div style={{ flex: 1, maxWidth: 320, marginLeft: 12,
                      background: "var(--bg)", border: "1px solid var(--line)",
                      borderRadius: 10, padding: "8px 12px",
                      display: "flex", alignItems: "center", gap: 8 }}>
          <span style={{ color: COLORS.fg2 }}>{Ico.search}</span>
          <span style={{ fontSize: 13, color: COLORS.fg2 }}>Search address, owner, parcel…</span>
          <span style={{ marginLeft: "auto", fontSize: 10, color: COLORS.fg2, padding: "2px 6px",
                         background: "rgba(48,63,73,0.06)", borderRadius: 4, fontFamily: "monospace" }}>⌘K</span>
        </div>

        <PersonaChip persona={PERSONAS[0]} active size="sm"/>
        <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>
          {Ico.ai} Ask AI
        </button>
        <div style={{
          width: 36, height: 36, borderRadius: "50%",
          background: COLORS.brand, color: "#fff",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontWeight: 700,
        }}>AK</div>
      </div>

      {/* Body: rail · galaxy · property pane */}
      <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>
        {/* Left rail */}
        <div style={{
          width: 72, padding: "14px 0", background: "var(--surface)",
          borderRight: "1px solid var(--line)",
          display: "flex", flexDirection: "column", alignItems: "center", gap: 10,
          flexShrink: 0,
        }}>
          {[
            { ic: Ico.galaxy, on: true },
            { ic: Ico.map },
            { ic: Ico.layers },
            { ic: Ico.list },
            { ic: Ico.heart },
            { ic: Ico.user },
          ].map((b, i) => (
            <div key={i} style={{
              width: 44, height: 44, borderRadius: 12,
              background: b.on ? "var(--brand-gradient)" : "transparent",
              color: b.on ? "#fff" : COLORS.fg2,
              display: "flex", alignItems: "center", justifyContent: "center",
              boxShadow: b.on ? "0 6px 14px rgba(0,91,234,0.25)" : "none",
            }}>{b.ic}</div>
          ))}
          <div style={{ flex: 1 }}/>
          <div style={{
            width: 44, height: 44, borderRadius: 12,
            background: "var(--bg)", color: COLORS.fg1,
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.filter}</div>
        </div>

        {/* Center: galaxy */}
        <div style={{ flex: 1, position: "relative", padding: 14, overflow: "hidden" }}>
          <div style={{ position: "absolute", inset: 14, borderRadius: 14, background: "linear-gradient(180deg, #F1F4F8 0%, #F8F9FA 100%)",
                        boxShadow: "var(--shadow-card)" }}>
            {/* dot grid */}
            <div style={{
              position: "absolute", inset: 0,
              backgroundImage: "radial-gradient(circle, rgba(48,63,73,0.07) 1px, transparent 1.5px)",
              backgroundSize: "28px 28px", backgroundPosition: "14px 14px",
              opacity: 0.55, borderRadius: 14,
            }}/>
            {/* HUD */}
            <div className="hud" style={{ top: 14, left: 14 }}>
              <span className="hud__dot" style={{ background: COLORS.success }}/>
              {Ico.trend}<span>ROI</span><span style={{ color: COLORS.fg2 }}>/ value</span>
            </div>
            <div className="hud" style={{ top: 14, right: 14 }}>
              <span>847 properties</span>
            </div>
            {/* dots */}
            {points.map(p => (
              <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*1.2} color={p.color}
                         halo={p.roi >= 0.22} opacity={p.stage === "sold" ? 0.4 : 1}/>
            ))}
            {/* selected highlight */}
            <div style={{
              position: "absolute", left: "42%", top: "32%",
              transform: "translate(-50%,-50%)",
              width: 56, height: 56, borderRadius: "50%",
              border: `2px solid ${COLORS.brand}`, animation: "spin 8s linear infinite",
              borderTopColor: "transparent", pointerEvents: "none",
            }}/>
            {/* HUD bottom: stats strip */}
            <div style={{
              position: "absolute", bottom: 14, left: 14, right: 14,
              padding: "10px 16px", borderRadius: 12,
              background: "rgba(255,255,255,0.92)",
              backdropFilter: "blur(20px)",
              border: "1px solid var(--line)",
              display: "flex", gap: 24, alignItems: "center",
              fontSize: 13,
            }}>
              <span><b>847</b> <span style={{ color: COLORS.fg2 }}>showing</span></span>
              <span style={{ width: 1, alignSelf: "stretch", background: "var(--line)" }}/>
              <span><b style={{ color: COLORS.success }}>14.6%</b> <span style={{ color: COLORS.fg2 }}>avg ROI</span></span>
              <span style={{ width: 1, alignSelf: "stretch", background: "var(--line)" }}/>
              <span><b style={{ color: COLORS.brand }}>+24</b> <span style={{ color: COLORS.fg2 }}>new today</span></span>
              <span style={{ width: 1, alignSelf: "stretch", background: "var(--line)" }}/>
              <span><b style={{ color: COLORS.warning }}>6</b> <span style={{ color: COLORS.fg2 }}>auctions next 7d</span></span>
              <span style={{ flex: 1 }}/>
              <Badge tone="hot">Hot · Duval Mar</Badge>
            </div>
          </div>
        </div>

        {/* Right pane: property detail */}
        <div style={{
          width: 360, padding: "14px 14px 14px 0", flexShrink: 0,
          display: "flex", flexDirection: "column", gap: 12, overflow: "auto",
        }}>
          <div className="surface-card" style={{ padding: 0, overflow: "hidden" }}>
            <PropertyImage height={130} tone="desert"/>
            <div style={{ padding: 14 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
                <GradeBadge grade={grade}/>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 14, fontWeight: 700, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{selected.address}</div>
                  <div style={{ fontSize: 11, color: COLORS.fg2 }}>{selected.city}, {selected.state}</div>
                </div>
                <Badge tone="info">LIEN</Badge>
              </div>
              <div style={{ display: "flex", gap: 6 }}>
                <StatTile label="Tax" value={usd(selected.tax)} accent={COLORS.brand}/>
                <StatTile label="ROI" value={pct(selected.roi)} accent={COLORS.success}/>
                <StatTile label="Risk" value={`${selected.risk}/100`} accent={colorByRisk(selected.risk)}/>
              </div>
            </div>
          </div>

          <div className="surface-card" style={{ padding: 14 }}>
            <SectionHead title="Risk profile" sub="6 factors" right={<Badge tone="good">Below median</Badge>}/>
            <div style={{ display: "flex", justifyContent: "center" }}>
              <RiskRadarChart scores={{ legal:28, market:42, location:35, condition:58, financial:22, competition:72 }} size={180}/>
            </div>
          </div>

          <div className="surface-card" style={{ padding: 14 }}>
            <SectionHead title="AI insight"/>
            <div style={{ fontSize: 12, color: COLORS.fg1, lineHeight: 1.5 }}>
              High ROI but multi-year distressed. Senior owner with <b>strong redemption probability</b> — you likely earn 16% interest, not the deed.
            </div>
            <div style={{ display: "flex", gap: 4, marginTop: 8 }}>
              <Badge tone="hot">3yr stack</Badge>
              <Badge tone="purple">Senior</Badge>
              <Badge tone="good">+ Zillow</Badge>
            </div>
          </div>

          <button className="cta" style={{ padding: "12px", fontSize: 14 }}>Make offer · $12,450</button>
        </div>
      </div>

      <style>{`@keyframes spin { 100% { transform: translate(-50%,-50%) rotate(360deg); } }`}</style>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 2. Tablet Kanban — workflow board with columns
// ──────────────────────────────────────────────────────────────────
function TabletKanbanScreen() {
  const cols = [
    { id: "watching", title: "Watching",   color: COLORS.fg2,    count: 24, sub: "Long-lead pool" },
    { id: "research", title: "Researching",color: COLORS.brand,  count: 8,  sub: "Under due diligence" },
    { id: "bid",      title: "Bidding",    color: COLORS.warning, count: 5,  sub: "Active or about to bid" },
    { id: "won",      title: "Won",        color: COLORS.success, count: 14, sub: "Held / redeeming" },
    { id: "redeemed", title: "Redeemed",   color: COLORS.cyan,    count: 9,  sub: "Cash returned" },
    { id: "archive",  title: "Archive",    color: COLORS.fg2,     count: 47, sub: "Passed / failed" },
  ];

  // Generate cards per column
  const cards = [
    { col: "watching", addr: "1428 Magnolia Blvd", city: "Orlando, FL",     g: "B", tax: "$8.4k",  roi: "16%", badges: ["NEW"] },
    { col: "watching", addr: "2901 Sycamore St",  city: "Phoenix, AZ",     g: "C", tax: "$5.1k",  roi: "12%", badges: ["FLOOD"] },
    { col: "watching", addr: "5407 Birch Way",    city: "Tucson, AZ",      g: "A", tax: "$22.0k", roi: "21%", badges: ["HIGHROI"] },
    { col: "watching", addr: "812 Lake Shore Rd", city: "Jacksonville, FL", g: "B", tax: "$11.3k", roi: "14%", badges: ["HOMESTEAD"] },
    { col: "research", addr: "1247 Oak Street",   city: "Phoenix, AZ",     g: "A", tax: "$12.5k", roi: "18%", badges: ["MULTI","HIGHROI"], dragging: true },
    { col: "research", addr: "5602 Palm Ave",     city: "Tucson, AZ",      g: "B", tax: "$7.8k",  roi: "14%", badges: ["SENIOR"] },
    { col: "research", addr: "920 Cedar Ln",      city: "Phoenix, AZ",     g: "C", tax: "$3.2k",  roi: "9%",  badges: ["QUICKPAY"] },
    { col: "bid",      addr: "318 Hilltop Drive", city: "Orlando, FL",     g: "A", tax: "$18.0k", roi: "22%", badges: ["AUCTION"], when: "in 4d" },
    { col: "bid",      addr: "75 Maple Drive",    city: "Jacksonville, FL", g: "B", tax: "$9.6k",  roi: "17%", badges: ["AUCTION"], when: "in 9d" },
    { col: "won",      addr: "2840 Elm Road",     city: "Phoenix, AZ",     g: "A", tax: "$14.4k", roi: "19%", badges: ["HELD"], when: "84d held" },
    { col: "won",      addr: "1119 Pine Avenue",  city: "Orlando, FL",     g: "B", tax: "$6.7k",  roi: "16%", badges: ["HELD"], when: "12d held" },
    { col: "won",      addr: "4051 Sunset Ct",    city: "Jacksonville, FL", g: "B", tax: "$8.9k",  roi: "15%", badges: ["HELD"], when: "201d" },
    { col: "redeemed", addr: "707 Sycamore St",   city: "Tucson, AZ",      g: "A", tax: "+$1,994", roi: "16%", badges: ["PAYOUT"] },
    { col: "redeemed", addr: "210 Hilltop Dr",    city: "Orlando, FL",     g: "B", tax: "+$842",   roi: "14%", badges: ["PAYOUT"] },
    { col: "archive",  addr: "9 Maple Dr",        city: "Tucson, AZ",      g: "F", tax: "$2.1k",  roi: "—",   badges: ["PASSED"] },
  ];

  return (
    <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <div style={{
        display: "flex", alignItems: "center", padding: "14px 22px", gap: 14,
        background: "var(--surface)", borderBottom: "1px solid var(--line)", flexShrink: 0,
      }}>
        <div>
          <div style={{ fontSize: 18, fontWeight: 700 }}>Pipeline</div>
          <div style={{ fontSize: 11, color: COLORS.fg2 }}>Drag cards between columns · live</div>
        </div>
        <div style={{ marginLeft: 16, display: "flex", gap: 4, padding: 4,
                      background: "var(--bg)", borderRadius: 10, border: "1px solid var(--line)" }}>
          {["My pipeline","Family shared","Team"].map((t, i) => (
            <div key={t} style={{
              padding: "6px 14px", borderRadius: 7, fontSize: 12.5, fontWeight: 600,
              background: i === 0 ? "var(--surface)" : "transparent",
              color: i === 0 ? COLORS.fg1 : COLORS.fg2,
              boxShadow: i === 0 ? "var(--shadow-card)" : "none",
            }}>{t}</div>
          ))}
        </div>
        <div style={{ flex: 1 }}/>
        <Badge tone="good">+$4,830 this month</Badge>
        <button className="cta cta--ghost" style={{ padding: "8px 14px", fontSize: 13 }}>
          {Ico.filter} Filter
        </button>
        <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>
          {Ico.plus} Add lien
        </button>
      </div>

      <div style={{ flex: 1, padding: 18, display: "grid",
                    gridTemplateColumns: `repeat(${cols.length}, minmax(170px, 1fr))`,
                    gap: 12, overflow: "auto" }}>
        {cols.map(col => (
          <div key={col.id} style={{
            background: "var(--bg)", borderRadius: 14, padding: 10,
            border: "1px solid var(--line)",
            display: "flex", flexDirection: "column", gap: 8, minWidth: 0,
            position: "relative",
          }}>
            <div style={{ display: "flex", alignItems: "center", gap: 8, padding: "4px 4px 0" }}>
              <span style={{ width: 8, height: 8, borderRadius: "50%", background: col.color }}/>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: COLORS.fg1 }}>{col.title}</div>
                <div style={{ fontSize: 10, color: COLORS.fg2 }}>{col.sub}</div>
              </div>
              <span style={{
                padding: "2px 7px", borderRadius: 999, fontSize: 11, fontWeight: 700,
                background: col.color + "1c", color: col.color,
              }}>{col.count}</span>
            </div>

            {/* drop indicator on Research column */}
            {col.id === "research" && (
              <div style={{
                height: 90, borderRadius: 10, marginBottom: 2,
                border: `2px dashed ${col.color}`,
                background: col.color + "0a",
                display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 11, color: col.color, fontWeight: 600,
              }}>Drop to move here</div>
            )}

            {cards.filter(c => c.col === col.id).map((c, i) => (
              <div key={c.addr} className="surface-card" style={{
                padding: 10, cursor: "grab",
                transform: c.dragging ? "rotate(-3deg) scale(1.04)" : "none",
                boxShadow: c.dragging ? "0 14px 32px rgba(0,91,234,0.22), 0 0 0 2px var(--brand-blue)" : "var(--shadow-card)",
                position: c.dragging ? "relative" : "static",
                zIndex: c.dragging ? 10 : 1,
              }}>
                <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 6 }}>
                  <GradeBadge grade={c.g} size="sm"/>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 12, fontWeight: 700, lineHeight: 1.2, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{c.addr}</div>
                    <div style={{ fontSize: 10, color: COLORS.fg2, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{c.city}</div>
                  </div>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", fontSize: 11, color: COLORS.fg2 }}>
                  <span style={{ fontWeight: 700, color: COLORS.fg1 }}>{c.tax}</span>
                  <span style={{ fontWeight: 700, color: COLORS.success }}>{c.roi}</span>
                </div>
                {c.when && (
                  <div style={{ fontSize: 10, color: COLORS.fg2, marginTop: 4 }}>{c.when}</div>
                )}
                <div style={{ display: "flex", gap: 3, marginTop: 6, flexWrap: "wrap" }}>
                  {c.badges.map(b => (
                    <span key={b} style={{
                      padding: "1px 5px", fontSize: 8, fontWeight: 700,
                      background: "rgba(48,63,73,0.06)", color: COLORS.fg1,
                      borderRadius: 3, letterSpacing: 0.05,
                    }}>{b}</span>
                  ))}
                </div>
              </div>
            ))}

            <div style={{
              padding: "10px 8px", borderRadius: 8,
              border: "1px dashed var(--line)",
              color: COLORS.fg2, fontSize: 11, textAlign: "center", cursor: "pointer",
            }}>+ add card</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 3. Tablet Split-Screen (iPad multitasking) — Safari + Tax Lien
// ──────────────────────────────────────────────────────────────────
function TabletSplitScreen() {
  return (
    <div style={{ width: "100%", height: "100%", display: "flex", overflow: "hidden", background: "#2A2A33" }}>
      {/* Left app: Safari with county tax sale page */}
      <div style={{
        flex: 1, background: "var(--surface)", margin: "10px 5px 10px 10px",
        borderRadius: 12, overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: "0 8px 24px rgba(0,0,0,0.2)",
      }}>
        <div style={{
          height: 36, background: "rgba(0,0,0,0.04)", display: "flex", alignItems: "center",
          padding: "0 12px", gap: 8, borderBottom: "1px solid var(--line)",
        }}>
          <div style={{ display: "flex", gap: 6 }}>
            {[Ico.back,Ico.back,Ico.refresh].map((ic,i) => <span key={i} style={{ color: COLORS.fg2, transform: i===1?"scaleX(-1)":"none", display: "inline-flex" }}>{ic}</span>)}
          </div>
          <div style={{ flex: 1, padding: "4px 12px", background: "var(--bg)",
                        borderRadius: 6, fontSize: 12, color: COLORS.fg2 }}>
            🔒 maricopa.gov/treasurer/sales
          </div>
        </div>
        <div style={{ flex: 1, padding: "24px 30px", overflow: "auto" }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600 }}>MARICOPA COUNTY · TREASURER</div>
          <div style={{ fontSize: 24, fontWeight: 700, marginTop: 6 }}>Annual Tax Lien Sale</div>
          <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 6, lineHeight: 1.4 }}>
            The Maricopa County Treasurer's Tax Lien Sale will take place on Tuesday, June 15, 2026, beginning at 10:00 AM MST.
          </div>
          <div style={{ marginTop: 16, padding: 14, background: "var(--bg)", borderRadius: 8, fontFamily: "monospace", fontSize: 12 }}>
            APN: 123-45-678 · 1247 Oak Street · Phoenix<br/>
            Tax due: $12,450.13<br/>
            Year owed: 2023, 2024, 2025<br/>
            Max bid-down interest: 16%<br/>
            Status: AVAILABLE
          </div>
        </div>
      </div>

      {/* Resize handle */}
      <div style={{ width: 10, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <div style={{ width: 4, height: 40, borderRadius: 2, background: "rgba(255,255,255,0.4)" }}/>
      </div>

      {/* Right app: Tax Lien Galaxy (in narrow layout) */}
      <div style={{
        width: 420, background: "var(--bg)", margin: "10px 10px 10px 5px",
        borderRadius: 12, overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: "0 8px 24px rgba(0,0,0,0.2)",
      }}>
        <div style={{
          padding: "12px 16px", background: "var(--surface)",
          borderBottom: "1px solid var(--line)", display: "flex", alignItems: "center", gap: 10,
        }}>
          <div style={{
            width: 26, height: 26, borderRadius: 8,
            background: "var(--brand-gradient)", color: "#fff",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.galaxy}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700 }}>1247 Oak Street</div>
            <div style={{ fontSize: 10, color: COLORS.fg2 }}>Imported from clipboard · APN matched</div>
          </div>
          <Badge tone="good">Matched</Badge>
        </div>
        <div style={{ flex: 1, padding: 12, overflow: "auto" }}>
          <div className="surface-card" style={{ padding: 0, overflow: "hidden", marginBottom: 10 }}>
            <PropertyImage height={120} tone="desert" badge={
              <div style={{ position: "absolute", top: 8, left: 8 }}>
                <GradeBadge grade="A"/>
              </div>
            }/>
            <div style={{ padding: 12 }}>
              <div style={{ fontSize: 14, fontWeight: 700 }}>1247 Oak Street</div>
              <div style={{ fontSize: 11, color: COLORS.fg2 }}>Maricopa · 123-45-678</div>
              <div style={{ display: "flex", gap: 6, marginTop: 10 }}>
                <StatTile label="Lien" value="$12,450" accent={COLORS.brand}/>
                <StatTile label="ROI" value="18%" accent={COLORS.success}/>
                <StatTile label="FVI" value="8.2"/>
              </div>
            </div>
          </div>

          <div className="surface-card" style={{ padding: 12 }}>
            <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600, textTransform: "uppercase", letterSpacing: 0.06 }}>Drag-in detected</div>
            <div style={{ fontSize: 12, color: COLORS.fg1, marginTop: 4, lineHeight: 1.4 }}>
              Drag the address bar from Safari into the Galaxy to instantly add this lien to your pipeline.
            </div>
            <button className="cta" style={{ width: "100%", padding: "10px", fontSize: 13, marginTop: 10 }}>
              {Ico.plus} Add to Researching
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 4. Tablet Comparison Wall — 4 properties side by side, dragged-apart
// ──────────────────────────────────────────────────────────────────
function TabletCompareScreen() {
  const props = [
    { addr: "1247 Oak Street", city: "Phoenix · Maricopa",  g: "A", value: "$89k", tax: "$12.5k", roi: "18%", risk: 32, fvi: 8.2, payback: "8mo", redemp: "74%", win: 5 },
    { addr: "5602 Palm Ave",   city: "Tucson · Pima",       g: "B", value: "$64k", tax: "$7.8k",  roi: "14%", risk: 51, fvi: 7.1, payback: "14mo", redemp: "68%", win: 1 },
    { addr: "2840 Hilltop Dr", city: "Orlando · Orange",    g: "A", value: "$67k", tax: "$9.1k",  roi: "22%", risk: 28, fvi: 8.6, payback: "6mo", redemp: "81%", win: 4 },
    { addr: "75 Maple Drive",  city: "Jacksonville · Duval", g: "C", value: "$52k", tax: "$6.4k",  roi: "11%", risk: 64, fvi: 6.2, payback: "18mo", redemp: "58%", win: 0 },
  ];

  return (
    <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <div style={{
        display: "flex", alignItems: "center", padding: "14px 24px", gap: 14,
        background: "var(--surface)", borderBottom: "1px solid var(--line)",
      }}>
        <div>
          <div style={{ fontSize: 18, fontWeight: 700 }}>Compare 4 properties</div>
          <div style={{ fontSize: 11, color: COLORS.fg2 }}>Two-hand drag · pinch any column to focus</div>
        </div>
        <div style={{ flex: 1 }}/>
        <Badge tone="good">Hilltop Dr leads · best in 4 of 9</Badge>
        <button className="cta cta--ghost" style={{ padding: "8px 14px", fontSize: 13 }}>Save view</button>
        <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>Choose Hilltop</button>
      </div>

      <div style={{ flex: 1, padding: 24, display: "grid",
                    gridTemplateColumns: "120px repeat(4, 1fr)", gap: 14, overflow: "auto" }}>
        {/* row labels column */}
        <div style={{ display: "flex", flexDirection: "column", gap: 8, paddingTop: 196 }}>
          {[
            "Investment grade",
            "Assessed value",
            "Tax due",
            "Expected ROI",
            "Risk score",
            "FVI",
            "Payback",
            "Redemption prob.",
            "Property type",
          ].map(r => (
            <div key={r} style={{ height: 48, display: "flex", alignItems: "center",
                                  fontSize: 11, color: COLORS.fg2, fontWeight: 600,
                                  borderBottom: "1px dashed var(--line)" }}>{r}</div>
          ))}
        </div>

        {props.map((p, i) => {
          const winner = i === 2;
          return (
            <div key={p.addr} className="surface-card" style={{
              padding: 0, overflow: "hidden",
              border: winner ? `2px solid ${COLORS.success}` : "0",
              boxShadow: winner ? `var(--shadow-card), 0 0 0 4px ${COLORS.success}12` : "var(--shadow-card)",
            }}>
              <PropertyImage height={140} tone={["desert","cool","forest","warm"][i]}/>
              <div style={{ padding: 14 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 6 }}>
                  <GradeBadge grade={p.g}/>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 13, fontWeight: 700, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{p.addr}</div>
                    <div style={{ fontSize: 11, color: COLORS.fg2 }}>{p.city}</div>
                  </div>
                  {winner && <Badge tone="good">✓ Lead</Badge>}
                </div>
                {/* comparison rows */}
                {[
                  { v: <GradeBadge grade={p.g} size="sm"/>, raw: p.g },
                  { v: p.value },
                  { v: p.tax },
                  { v: <span style={{ color: COLORS.success, fontWeight: 700 }}>{p.roi}</span> },
                  { v: <span style={{ color: colorByRisk(p.risk), fontWeight: 700 }}>{p.risk}/100</span> },
                  { v: p.fvi },
                  { v: p.payback },
                  { v: p.redemp },
                  { v: "Residential" },
                ].map((r, ri) => (
                  <div key={ri} style={{
                    height: 48, display: "flex", alignItems: "center",
                    fontSize: 14, fontWeight: 600, color: COLORS.fg1,
                    borderBottom: ri < 8 ? "1px dashed var(--line)" : "0",
                  }}>{r.v}</div>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 5. Tablet Multi-window — Galaxy + Property + AI side-by-side
// ──────────────────────────────────────────────────────────────────
function TabletMultiPaneScreen() {
  const points = layoutFor("roi");
  return (
    <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <div style={{
        display: "flex", alignItems: "center", padding: "12px 22px", gap: 14,
        background: "var(--surface)", borderBottom: "1px solid var(--line)",
      }}>
        <div style={{ fontSize: 17, fontWeight: 700 }}>Workspace</div>
        <Badge tone="info">3 panes synced</Badge>
        <div style={{ flex: 1 }}/>
        <span style={{ fontSize: 11, color: COLORS.fg2 }}>Drag handle to resize · drop card into pane to open</span>
      </div>

      <div style={{ flex: 1, display: "flex", gap: 1, background: "var(--line)", overflow: "hidden" }}>
        {/* Pane 1 — Galaxy */}
        <div style={{ flex: 1, background: "var(--surface)", display: "flex", flexDirection: "column", overflow: "hidden" }}>
          <PaneHeader title="Galaxy" sub="847 properties" right={Ico.filter}/>
          <div style={{ flex: 1, position: "relative", background: "var(--bg)", margin: 10, borderRadius: 10 }}>
            {points.map(p => <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*1.1} color={p.color}/>)}
          </div>
        </div>

        {/* Pane 2 — Selected property full detail */}
        <div style={{ flex: 1.1, background: "var(--surface)", display: "flex", flexDirection: "column", overflow: "auto" }}>
          <PaneHeader title="1247 Oak Street" sub="Maricopa · LIEN" right={Ico.xray}/>
          <div style={{ padding: "0 12px 12px" }}>
            <PropertyImage height={130} tone="desert"/>
            <div style={{ display: "flex", gap: 6, marginTop: 10 }}>
              <StatTile label="Lien" value="$12,450" accent={COLORS.brand}/>
              <StatTile label="ROI" value="18.5%" accent={COLORS.success}/>
              <StatTile label="Risk" value="32" accent={COLORS.success}/>
            </div>
            <div className="surface-card" style={{ padding: 12, marginTop: 10, background: "var(--bg)" }}>
              <SectionHead title="Risk profile" sub="6 factors"/>
              <div style={{ display: "flex", justifyContent: "center" }}>
                <RiskRadarChart scores={{ legal:28, market:42, location:35, condition:58, financial:22, competition:72 }} size={140}/>
              </div>
            </div>

            <div className="surface-card" style={{ padding: 12, marginTop: 10, background: "var(--bg)" }}>
              <SectionHead title="Specs"/>
              <Row k="Bed · Bath"     v="3 · 2"/>
              <Row k="Building / Year" v="1,640 sqft · 1978"/>
              <Row k="Walkability"    v="64 / 100"/>
              <Row k="Schools"        v="7.8 / 10"/>
              <Row k="Flood zone"     v="Zone X" last/>
            </div>
          </div>
        </div>

        {/* Pane 3 — AI + insights */}
        <div style={{ flex: 0.9, background: "var(--surface)", display: "flex", flexDirection: "column", overflow: "auto" }}>
          <PaneHeader title="AI Copilot" sub="Listening to your selection" right={Ico.ai}/>
          <div style={{ padding: "0 12px 12px" }}>
            <div style={{
              padding: 12, borderRadius: 12, marginBottom: 10,
              background: "linear-gradient(180deg, rgba(0,198,251,0.10) 0%, rgba(0,91,234,0.06) 100%)",
              border: `1px solid ${COLORS.brand}22`,
            }}>
              <div style={{ display: "flex", gap: 8, alignItems: "center", marginBottom: 8 }}>
                <div style={{ width: 24, height: 24, borderRadius: "50%", background: "var(--brand-gradient)", color: "#fff",
                              display: "flex", alignItems: "center", justifyContent: "center" }}>{Ico.ai}</div>
                <span style={{ fontSize: 11, fontWeight: 700, color: COLORS.brand, letterSpacing: 0.06, textTransform: "uppercase" }}>Summary</span>
              </div>
              <p style={{ fontSize: 13, color: COLORS.fg1, lineHeight: 1.5, margin: 0 }}>
                High ROI opportunity, but multi-year distressed. Senior owner with strong redemption probability — likely earns 16% interest, not deed.
              </p>
            </div>

            <SectionHead title="Insights" sub="4 critical"/>
            {[
              { ico: Ico.warn, c: COLORS.danger, t: "Flood zone AE", s: "FEMA hazard · insurance required" },
              { ico: Ico.refresh, c: COLORS.danger, t: "3 years delinquent", s: "Severely distressed" },
              { ico: Ico.trend, c: COLORS.success, t: "High ROI · 18.5%", s: "Top 12% in Maricopa" },
              { ico: Ico.shield, c: COLORS.purple, t: "Senior homeowner", s: "Ethical consideration" },
            ].map((ins, i) => (
              <div key={i} style={{ display: "flex", gap: 10, padding: "10px 0",
                                    borderBottom: i < 3 ? "1px solid var(--line)" : "none" }}>
                <div style={{ width: 28, height: 28, borderRadius: 6, background: ins.c+"1c", color: ins.c, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>{ins.ico}</div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 12.5, fontWeight: 600, color: COLORS.fg1 }}>{ins.t}</div>
                  <div style={{ fontSize: 11, color: COLORS.fg2, marginTop: 1, lineHeight: 1.3 }}>{ins.s}</div>
                </div>
              </div>
            ))}

            <div style={{ marginTop: 12, padding: 10, background: "var(--bg)", borderRadius: 10, display: "flex", alignItems: "center", gap: 8 }}>
              <span style={{ color: COLORS.brand }}>{Ico.mic}</span>
              <span style={{ fontSize: 12, color: COLORS.fg2, flex: 1 }}>Try: "compare with Hilltop"</span>
              <span style={{ fontSize: 10, padding: "2px 6px", background: "rgba(48,63,73,0.08)", borderRadius: 4, color: COLORS.fg2, fontFamily: "monospace" }}>⌥V</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function PaneHeader({ title, sub, right }) {
  return (
    <div style={{
      padding: "12px 14px", borderBottom: "1px solid var(--line)",
      display: "flex", alignItems: "center", gap: 8,
    }}>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 700 }}>{title}</div>
        <div style={{ fontSize: 11, color: COLORS.fg2 }}>{sub}</div>
      </div>
      {right && (
        <div style={{ width: 30, height: 30, borderRadius: 8, background: "var(--bg)", display: "flex", alignItems: "center", justifyContent: "center", color: COLORS.fg1 }}>
          {right}
        </div>
      )}
    </div>
  );
}

Object.assign(window, {
  TabletGalaxyScreen, TabletKanbanScreen, TabletSplitScreen,
  TabletCompareScreen, TabletMultiPaneScreen, PaneHeader,
});
