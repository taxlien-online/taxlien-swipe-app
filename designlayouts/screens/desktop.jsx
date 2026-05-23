// desktop.jsx — desktop screens (1440×900).
// Command center, 3D cube of dimensions, system tray dropdown, AR concept.

// ──────────────────────────────────────────────────────────────────
// 1. Command Center — full multi-pane desktop dashboard
// ──────────────────────────────────────────────────────────────────
function DesktopCommandCenter() {
  const points = layoutFor("roi");

  return (
    <div style={{ width: "100%", height: "100%", display: "flex", overflow: "hidden", fontFamily: "var(--font-family)" }}>
      {/* Left sidebar nav */}
      <div style={{
        width: 220, background: "var(--surface)", borderRight: "1px solid var(--line)",
        display: "flex", flexDirection: "column", flexShrink: 0,
      }}>
        <div style={{ padding: "16px 20px", display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{
            width: 30, height: 30, borderRadius: 8,
            background: "var(--brand-gradient)", color: "#fff",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.galaxy}</div>
          <div>
            <div style={{ fontSize: 14, fontWeight: 700 }}>Tax Lien Galaxy</div>
            <div style={{ fontSize: 10, color: COLORS.fg2 }}>PRO · Anton K.</div>
          </div>
        </div>

        <div style={{ padding: "0 12px", flex: 1, overflow: "auto" }}>
          <NavGroup label="Workspace" items={[
            { ic: Ico.galaxy, k: "Galaxy", active: true, count: "847" },
            { ic: Ico.map,    k: "Map" },
            { ic: Ico.layers, k: "Kanban", count: "14" },
            { ic: Ico.list,   k: "List" },
            { ic: Ico.cal,    k: "Heatmap" },
            { ic: Ico.link,   k: "Graph" },
          ]}/>
          <NavGroup label="Saved" items={[
            { ic: Ico.heart,  k: "Florida picks", count: "12", color: COLORS.brand },
            { ic: Ico.heart,  k: "Family shared", count: "8",  color: COLORS.purple },
            { ic: Ico.heart,  k: "Quick flips",   count: "4",  color: COLORS.success },
            { ic: Ico.plus,   k: "New board" },
          ]}/>
          <NavGroup label="Analytics" items={[
            { ic: Ico.trend, k: "Portfolio" },
            { ic: Ico.warn,  k: "Risk profile" },
            { ic: Ico.user,  k: "Owners" },
            { ic: Ico.shield, k: "Ethics filter" },
          ]}/>
          <NavGroup label="Account" items={[
            { ic: Ico.user,    k: "Profile" },
            { ic: Ico.shield,  k: "API access · ELITE", locked: true },
            { ic: Ico.refresh, k: "Pricing & billing" },
          ]}/>
        </div>

        <div style={{ padding: 12, borderTop: "1px solid var(--line)" }}>
          <div style={{
            display: "flex", alignItems: "center", gap: 8, padding: "8px 10px",
            borderRadius: 10, background: "var(--bg)",
          }}>
            <div style={{ width: 28, height: 28, borderRadius: "50%", background: COLORS.brand, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, fontSize: 12 }}>AK</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 12, fontWeight: 600 }}>Anton K.</div>
              <div style={{ fontSize: 10, color: COLORS.fg2 }}>$184k portfolio</div>
            </div>
            <span style={{ color: COLORS.fg2 }}>{Ico.more}</span>
          </div>
        </div>
      </div>

      {/* Main */}
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        {/* Top bar */}
        <div style={{
          padding: "10px 22px", borderBottom: "1px solid var(--line)",
          display: "flex", alignItems: "center", gap: 14, background: "var(--surface)",
        }}>
          <div>
            <div style={{ fontSize: 18, fontWeight: 700, letterSpacing: -0.01 }}>Galaxy · ROI dimension</div>
            <div style={{ fontSize: 11, color: COLORS.fg2 }}>FL · AZ · IL · live · updated 14m ago</div>
          </div>
          <div style={{ display: "flex", gap: 4, padding: 4, background: "var(--bg)", borderRadius: 10, marginLeft: 12 }}>
            {["ROI","Risk","Stage","County","Date","FVI","Type"].map((d, i) => (
              <div key={d} style={{
                padding: "6px 12px", borderRadius: 7, fontSize: 12, fontWeight: 600,
                background: i === 0 ? "var(--surface)" : "transparent",
                color: i === 0 ? COLORS.fg1 : COLORS.fg2,
                boxShadow: i === 0 ? "var(--shadow-card)" : "none",
              }}>{d}</div>
            ))}
          </div>
          <div style={{ flex: 1 }}/>
          <div style={{ display: "flex", alignItems: "center", gap: 6, padding: "6px 12px",
                        background: "var(--bg)", border: "1px solid var(--line)", borderRadius: 8,
                        fontSize: 12, color: COLORS.fg2, minWidth: 360 }}>
            {Ico.search}
            <span>Search address, owner, parcel · or "show FL ROI > 20%"</span>
            <span style={{ marginLeft: "auto", padding: "2px 6px", background: "rgba(48,63,73,0.06)", borderRadius: 4, fontFamily: "monospace", fontSize: 10 }}>⌘K</span>
          </div>
          <PersonaChip persona={PERSONAS[0]} active/>
          <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>{Ico.ai} Copilot</button>
          <div style={{ width: 34, height: 34, borderRadius: "50%", background: "var(--bg)", color: COLORS.fg1, display: "flex", alignItems: "center", justifyContent: "center", position: "relative" }}>
            {Ico.bolt}
            <span style={{ position: "absolute", top: 4, right: 4, width: 8, height: 8, borderRadius: "50%", background: COLORS.danger, border: "2px solid var(--surface)" }}/>
          </div>
        </div>

        {/* Body grid */}
        <div style={{
          flex: 1, display: "grid",
          gridTemplateColumns: "1fr 360px",
          gridTemplateRows: "1fr 280px",
          gap: 12, padding: 12, background: "var(--bg)", overflow: "hidden",
        }}>
          {/* Galaxy hero (top-left) */}
          <div className="surface-card" style={{ padding: 14, position: "relative", overflow: "hidden" }}>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 10 }}>
              <div>
                <div style={{ fontSize: 11, color: COLORS.brand, textTransform: "uppercase", fontWeight: 700, letterSpacing: 0.06 }}>Property Galaxy</div>
                <div style={{ fontSize: 16, fontWeight: 700 }}>847 properties · ROI × value</div>
              </div>
              <div style={{ display: "flex", gap: 6 }}>
                <Badge tone="good">+24 new today</Badge>
                <Badge tone="info">14.6% avg ROI</Badge>
              </div>
            </div>
            <div style={{ position: "absolute", inset: "60px 14px 14px", background: "linear-gradient(180deg, #F1F4F8 0%, #F8F9FA 100%)", borderRadius: 12 }}>
              {/* dot grid */}
              <div style={{ position: "absolute", inset: 0, borderRadius: 12,
                            backgroundImage: "radial-gradient(circle, rgba(48,63,73,0.07) 1px, transparent 1.5px)",
                            backgroundSize: "26px 26px", opacity: 0.55 }}/>
              {points.map(p => (
                <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*1.3} color={p.color}
                           halo={p.roi >= 0.22} opacity={p.stage === "sold" ? 0.4 : 1}/>
              ))}
              {/* selection */}
              <svg style={{ position: "absolute", inset: 0, pointerEvents: "none" }}
                   viewBox="0 0 100 100" preserveAspectRatio="none">
                <path d="M 35 18 C 50 10, 70 12, 78 28 S 80 60, 65 65 S 30 60, 25 42 S 25 25, 35 18 Z"
                      fill="rgba(0,91,234,0.06)" stroke={COLORS.brand}
                      strokeWidth="0.25" strokeDasharray="1 1"/>
              </svg>
              {/* zone label */}
              <div style={{ position: "absolute", top: 30, right: 50,
                            padding: "5px 10px", borderRadius: 8,
                            background: "rgba(31,182,122,0.12)", color: COLORS.success,
                            fontSize: 11, fontWeight: 700, letterSpacing: 0.05, textTransform: "uppercase" }}>
                High-ROI cluster · 47
              </div>
            </div>
          </div>

          {/* Right side: portfolio summary + watchlist top */}
          <div style={{ display: "flex", flexDirection: "column", gap: 12, overflow: "auto" }}>
            <div className="surface-card" style={{ padding: 14,
                  background: "linear-gradient(180deg, #E6F8FF 0%, #E6EEFD 100%)",
                  border: `1px solid ${COLORS.brand}22` }}>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                <div>
                  <div style={{ fontSize: 10, color: COLORS.brand, fontWeight: 700, textTransform: "uppercase", letterSpacing: 0.06 }}>Portfolio</div>
                  <div style={{ fontSize: 26, fontWeight: 800, letterSpacing: -0.01, marginTop: 4 }}>$184,200</div>
                  <div style={{ fontSize: 11, color: COLORS.success, fontWeight: 600, marginTop: 2 }}>+$4,830 30d · 14 active</div>
                </div>
                <svg width="80" height="40" viewBox="0 0 80 40">
                  <polyline points="0,30 10,28 20,22 30,24 40,18 50,10 60,12 70,6 80,4"
                            fill="none" stroke={COLORS.brand} strokeWidth="2"/>
                  <path d="M0,30 10,28 20,22 30,24 40,18 50,10 60,12 70,6 80,4 L80,40 L0,40 Z"
                        fill={COLORS.brand} opacity="0.12"/>
                </svg>
              </div>
              <div style={{ display: "flex", gap: 6, marginTop: 12 }}>
                <StatTile label="ROI" value="15.4%" accent={COLORS.success}/>
                <StatTile label="Redeem" value="9/14" accent={COLORS.brand}/>
                <StatTile label="Deeds" value="2"/>
              </div>
            </div>

            <div className="surface-card" style={{ padding: 14 }}>
              <SectionHead title="Today" sub="Live alerts" right={<Badge tone="hot">3 new</Badge>}/>
              {[
                { ic: Ico.warn, c: COLORS.danger, t: "Maricopa auction · 30 min", s: "142 liens · 18%" },
                { ic: Ico.trend, c: COLORS.success, t: "Oak St redeemed", s: "+$1,994 (16% APR)" },
                { ic: Ico.ai,    c: COLORS.brand,   t: "4 Flipper matches · Duval", s: "Avg 22% ROI · 3d window" },
              ].map((n, i) => (
                <div key={i} style={{ display: "flex", gap: 10, padding: "8px 0",
                                       borderTop: i > 0 ? "1px solid var(--line)" : "none" }}>
                  <div style={{ width: 26, height: 26, borderRadius: 6, background: n.c+"1c", color: n.c,
                                display: "flex", alignItems: "center", justifyContent: "center" }}>{n.ic}</div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 12, fontWeight: 600 }}>{n.t}</div>
                    <div style={{ fontSize: 11, color: COLORS.fg2, lineHeight: 1.3 }}>{n.s}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Bottom-left: Kanban mini-row */}
          <div className="surface-card" style={{ padding: 14, overflow: "hidden", display: "flex", flexDirection: "column" }}>
            <SectionHead title="Pipeline" sub="Drag cards across stages"
              right={<button className="cta cta--ghost" style={{ padding: "5px 10px", fontSize: 11 }}>Open full board →</button>}/>
            <div style={{ flex: 1, display: "grid", gridTemplateColumns: "repeat(5, 1fr)", gap: 8, overflow: "auto" }}>
              {[
                { name: "Watching",   color: COLORS.fg2,     count: 24, cards: ["Magnolia", "Sycamore", "Birch"] },
                { name: "Researching", color: COLORS.brand,   count: 8,  cards: ["Oak ★", "Palm", "Cedar"] },
                { name: "Bidding",     color: COLORS.warning, count: 5,  cards: ["Hilltop · 4d", "Maple · 9d"] },
                { name: "Won",         color: COLORS.success, count: 14, cards: ["Elm · 84d", "Pine · 12d"] },
                { name: "Redeemed",    color: COLORS.cyan,    count: 9,  cards: ["Sycamore · +$1,994"] },
              ].map(c => (
                <div key={c.name} style={{ background: "var(--bg)", borderRadius: 10, padding: 8, display: "flex", flexDirection: "column", gap: 4 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                    <span style={{ width: 7, height: 7, borderRadius: "50%", background: c.color }}/>
                    <span style={{ fontSize: 11, fontWeight: 700, color: COLORS.fg1 }}>{c.name}</span>
                    <span style={{ marginLeft: "auto", fontSize: 10, padding: "1px 5px", borderRadius: 999, background: c.color+"1c", color: c.color, fontWeight: 700 }}>{c.count}</span>
                  </div>
                  {c.cards.map(card => (
                    <div key={card} style={{
                      padding: "6px 8px", borderRadius: 6,
                      background: "var(--surface)", fontSize: 11, color: COLORS.fg1, fontWeight: 500,
                      border: "1px solid var(--line)",
                    }}>{card}</div>
                  ))}
                </div>
              ))}
            </div>
          </div>

          {/* Bottom-right: AI Copilot dock */}
          <div className="surface-card" style={{ padding: 14, display: "flex", flexDirection: "column" }}>
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
              <div style={{ width: 26, height: 26, borderRadius: "50%", background: "var(--brand-gradient)", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center" }}>{Ico.ai}</div>
              <div>
                <div style={{ fontSize: 13, fontWeight: 700 }}>AI Copilot</div>
                <div style={{ fontSize: 10, color: COLORS.fg2 }}>Last query · 2m ago</div>
              </div>
            </div>
            <div style={{
              flex: 1, padding: 10, background: "var(--bg)", borderRadius: 8,
              fontSize: 12, color: COLORS.fg1, lineHeight: 1.4, overflow: "auto",
            }}>
              <div style={{ color: COLORS.brand, fontWeight: 600, marginBottom: 4 }}>You</div>
              <div style={{ marginBottom: 10 }}>show flipper matches in florida with roi above 20%</div>
              <div style={{ color: COLORS.success, fontWeight: 600, marginBottom: 4 }}>Copilot</div>
              <div style={{ marginBottom: 6 }}>Found <b>23 properties</b> in FL. Avg ROI <b>17.3%</b>, top 5 above 22%. Highlighted in galaxy.</div>
              <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
                <Badge tone="good">23 matches</Badge>
                <Badge tone="info">2.1s</Badge>
                <Badge tone="purple">DL-v2.4</Badge>
              </div>
            </div>
            <div style={{ marginTop: 8, padding: "8px 10px", background: "var(--bg)", borderRadius: 8,
                          border: `1.5px solid ${COLORS.brand}33`,
                          display: "flex", alignItems: "center", gap: 8 }}>
              <span style={{ color: COLORS.brand }}>{Ico.mic}</span>
              <span style={{ flex: 1, fontSize: 12, color: COLORS.fg2 }}>Ask anything…</span>
              <span style={{ fontSize: 10, padding: "2px 6px", borderRadius: 4, background: "rgba(48,63,73,0.06)", color: COLORS.fg2, fontFamily: "monospace" }}>⏎</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function NavGroup({ label, items }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ fontSize: 10, color: COLORS.fg2, fontWeight: 700, letterSpacing: 0.08, textTransform: "uppercase", padding: "0 8px 4px" }}>{label}</div>
      {items.map((it, i) => (
        <div key={it.k} style={{
          display: "flex", alignItems: "center", gap: 10, padding: "7px 10px",
          borderRadius: 8, cursor: "pointer",
          background: it.active ? "rgba(0,91,234,0.10)" : "transparent",
          color: it.active ? COLORS.brand : (it.locked ? COLORS.fg2 : COLORS.fg1),
          fontWeight: it.active ? 600 : 500, fontSize: 12.5,
          opacity: it.locked ? 0.65 : 1,
        }}>
          <span style={{ color: it.active ? COLORS.brand : (it.color || COLORS.fg2) }}>{it.ic}</span>
          <span style={{ flex: 1 }}>{it.k}</span>
          {it.count && (
            <span style={{
              padding: "1px 6px", borderRadius: 999, fontSize: 10, fontWeight: 700,
              background: it.active ? "var(--brand-blue)" : "rgba(48,63,73,0.08)",
              color: it.active ? "#fff" : COLORS.fg1,
            }}>{it.count}</span>
          )}
          {it.locked && <span style={{ fontSize: 9, padding: "1px 5px", background: "rgba(123,91,234,0.15)", color: COLORS.purple, borderRadius: 3, fontWeight: 700, letterSpacing: 0.04 }}>LOCK</span>}
        </div>
      ))}
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 2. Desktop Kanban — full board
// ──────────────────────────────────────────────────────────────────
function DesktopKanbanScreen() {
  return <TabletKanbanScreen/>; // same layout, fits the larger frame too
}

// ──────────────────────────────────────────────────────────────────
// 3. 3D Dimension Cube — full-screen 3D viz
// ──────────────────────────────────────────────────────────────────
function Desktop3DCubeScreen() {
  // 3D cube with axes Time × Value × Risk; properties as floating points.
  return (
    <div style={{ width: "100%", height: "100%", position: "relative",
                  background: "linear-gradient(135deg, #0F1024 0%, #050810 100%)",
                  overflow: "hidden", fontFamily: "var(--font-family)" }}>
      {/* nebula glow */}
      <div style={{ position: "absolute", top: -100, left: -100, width: 800, height: 800,
                    background: "radial-gradient(circle, rgba(123,91,234,0.18) 0%, transparent 60%)" }}/>
      <div style={{ position: "absolute", bottom: -150, right: -150, width: 700, height: 700,
                    background: "radial-gradient(circle, rgba(0,198,251,0.14) 0%, transparent 60%)" }}/>

      {/* Top toolbar */}
      <div style={{
        position: "absolute", top: 0, left: 0, right: 0,
        padding: "14px 24px", display: "flex", alignItems: "center", gap: 14,
        background: "rgba(15,16,36,0.75)", backdropFilter: "blur(20px)",
        borderBottom: "1px solid rgba(255,255,255,0.08)", color: "#fff", zIndex: 10,
      }}>
        <button style={{ background: "rgba(255,255,255,0.10)", border: 0, color: "#fff",
                          padding: "8px 12px", borderRadius: 8, fontSize: 12,
                          display: "inline-flex", alignItems: "center", gap: 6, cursor: "pointer" }}>
          {Ico.back} Exit 3D
        </button>
        <div style={{ marginLeft: 8 }}>
          <div style={{ fontSize: 16, fontWeight: 700 }}>Dimension Cube</div>
          <div style={{ fontSize: 11, color: "rgba(255,255,255,0.55)" }}>Time × Value × Risk · 847 properties</div>
        </div>
        <div style={{ flex: 1 }}/>
        {/* axis pickers */}
        {[
          { lab: "X axis", v: "Time", c: COLORS.cyan },
          { lab: "Y axis", v: "Value", c: COLORS.success },
          { lab: "Z axis", v: "Risk", c: COLORS.danger },
        ].map((a, i) => (
          <div key={a.lab} style={{
            padding: "6px 12px", borderRadius: 8,
            background: "rgba(255,255,255,0.06)",
            border: `1px solid ${a.c}55`,
          }}>
            <div style={{ fontSize: 9, color: a.c, fontWeight: 700, letterSpacing: 0.06, textTransform: "uppercase" }}>{a.lab}</div>
            <div style={{ fontSize: 12, fontWeight: 600, color: "#fff" }}>{a.v}</div>
          </div>
        ))}
        <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>{Ico.refresh} Auto-rotate</button>
      </div>

      {/* The 3D cube */}
      <svg viewBox="0 0 800 560" style={{
        position: "absolute", top: 70, left: 0, right: 0, margin: "auto", display: "block",
      }} width="100%" height="calc(100% - 90px)" preserveAspectRatio="xMidYMid meet">
        <defs>
          <linearGradient id="cubeFaceFront" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0" stopColor="rgba(0,198,251,0.07)"/>
            <stop offset="1" stopColor="rgba(0,91,234,0.04)"/>
          </linearGradient>
          <linearGradient id="cubeFaceSide" x1="0" y1="0" x2="1" y2="0">
            <stop offset="0" stopColor="rgba(123,91,234,0.10)"/>
            <stop offset="1" stopColor="rgba(123,91,234,0.04)"/>
          </linearGradient>
          <linearGradient id="cubeFaceTop">
            <stop offset="0" stopColor="rgba(31,182,122,0.10)"/>
            <stop offset="1" stopColor="rgba(31,182,122,0.04)"/>
          </linearGradient>
        </defs>

        {/* Cube projection: isometric-ish */}
        {/* back face */}
        <polygon points="220,160 580,160 580,460 220,460" fill="rgba(255,255,255,0.02)" stroke="rgba(255,255,255,0.18)" strokeWidth="1"/>
        {/* top face */}
        <polygon points="220,160 580,160 660,90 300,90"  fill="url(#cubeFaceTop)" stroke="rgba(31,182,122,0.45)" strokeWidth="1"/>
        {/* right face */}
        <polygon points="580,160 660,90 660,390 580,460" fill="url(#cubeFaceSide)" stroke="rgba(123,91,234,0.45)" strokeWidth="1"/>
        {/* front face */}
        <polygon points="220,160 580,160 580,460 220,460" fill="url(#cubeFaceFront)" stroke="rgba(0,198,251,0.45)" strokeWidth="1.5"/>

        {/* axis labels */}
        <text x="400" y="500" textAnchor="middle" fill={COLORS.cyan} fontSize="13" fontWeight="700" letterSpacing="0.06em">TIME →</text>
        <text x="180" y="310" textAnchor="middle" fill={COLORS.success} fontSize="13" fontWeight="700" letterSpacing="0.06em"
              transform="rotate(-90 180 310)">↑ VALUE</text>
        <text x="640" y="540" textAnchor="middle" fill={COLORS.danger} fontSize="13" fontWeight="700" letterSpacing="0.06em">↗ RISK</text>

        {/* grid on front face */}
        {[0,1,2,3,4].map(i => (
          <React.Fragment key={i}>
            <line x1={220 + i*72} y1="160" x2={220 + i*72} y2="460" stroke="rgba(0,198,251,0.10)" strokeWidth="0.5"/>
            <line x1="220" y1={160 + i*60} x2="580" y2={160 + i*60} stroke="rgba(0,198,251,0.10)" strokeWidth="0.5"/>
          </React.Fragment>
        ))}

        {/* properties as points (with depth) */}
        {Array.from({length: 140}).map((_, i) => {
          const seed = i * 137;
          // normalized 0..1 coords
          const t = (seed % 100) / 100;
          const v = ((seed * 7) % 100) / 100;
          const r = ((seed * 11) % 100) / 100;
          // depth-shift = r → push toward back
          const baseX = 220 + t * 360;
          const baseY = 460 - v * 300;
          const depthX = baseX + r * 80;
          const depthY = baseY - r * 70;
          const c = r < 0.35 ? COLORS.success : r < 0.65 ? COLORS.warning : COLORS.danger;
          const size = 3 + v * 5;
          // drop a line from front-plane to point (depth visualization)
          return (
            <React.Fragment key={i}>
              <line x1={baseX} y1={baseY} x2={depthX} y2={depthY} stroke={c} strokeWidth="0.4" opacity="0.25"/>
              <circle cx={depthX} cy={depthY} r={size} fill={c} opacity={0.85}
                      style={{ filter: `drop-shadow(0 0 ${size*1.5}px ${c})` }}/>
            </React.Fragment>
          );
        })}

        {/* selected highlighted property + label */}
        <circle cx="380" cy="280" r="8" fill="#fff" stroke={COLORS.brand} strokeWidth="2"/>
        <line x1="380" y1="280" x2="500" y2="220" stroke="rgba(255,255,255,0.5)" strokeWidth="0.8" strokeDasharray="2 2"/>
        <g transform="translate(500 200)">
          <rect x="0" y="0" width="170" height="46" rx="8" fill="rgba(15,16,36,0.92)" stroke="rgba(255,255,255,0.18)" strokeWidth="1"/>
          <text x="10" y="18" fill="#fff" fontSize="12" fontWeight="700">1247 Oak Street</text>
          <text x="10" y="36" fill="rgba(255,255,255,0.6)" fontSize="10">$89k · 18% ROI · Risk 32</text>
        </g>
      </svg>

      {/* Controls dock bottom */}
      <div style={{
        position: "absolute", left: "50%", bottom: 24, transform: "translateX(-50%)",
        display: "flex", gap: 6, padding: 8, borderRadius: 14,
        background: "rgba(15,16,36,0.75)", backdropFilter: "blur(20px)",
        border: "1px solid rgba(255,255,255,0.10)",
      }}>
        {[Ico.galaxy, Ico.refresh, Ico.search, Ico.layers, Ico.scale, Ico.ai].map((ic, i) => (
          <button key={i} style={{
            width: 42, height: 42, borderRadius: 10, border: 0,
            background: i === 0 ? "var(--brand-gradient)" : "rgba(255,255,255,0.08)",
            color: "#fff", display: "flex", alignItems: "center", justifyContent: "center",
            cursor: "pointer",
          }}>{ic}</button>
        ))}
      </div>

      {/* Legend */}
      <div style={{
        position: "absolute", right: 24, top: 96, width: 220,
        padding: 14, borderRadius: 12,
        background: "rgba(15,16,36,0.75)", backdropFilter: "blur(20px)",
        border: "1px solid rgba(255,255,255,0.10)", color: "#fff",
      }}>
        <div style={{ fontSize: 10, color: "rgba(255,255,255,0.55)", fontWeight: 700, letterSpacing: 0.08, textTransform: "uppercase", marginBottom: 8 }}>Legend</div>
        <div style={{ fontSize: 12, lineHeight: 1.5 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 4 }}>
            <span style={{ width: 10, height: 10, borderRadius: "50%", background: COLORS.success, boxShadow: `0 0 6px ${COLORS.success}` }}/>
            <span>Low risk &lt; 35</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 4 }}>
            <span style={{ width: 10, height: 10, borderRadius: "50%", background: COLORS.warning, boxShadow: `0 0 6px ${COLORS.warning}` }}/>
            <span>Medium 35-65</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ width: 10, height: 10, borderRadius: "50%", background: COLORS.danger, boxShadow: `0 0 6px ${COLORS.danger}` }}/>
            <span>High &gt; 65</span>
          </div>
        </div>
        <div style={{ fontSize: 10, color: "rgba(255,255,255,0.40)", marginTop: 10 }}>
          Drag = rotate · scroll = zoom · ⌘+click to lasso-select in 3D
        </div>
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 4. Desktop system tray — menubar dropdown
// ──────────────────────────────────────────────────────────────────
function DesktopTrayScreen() {
  return (
    <div style={{ width: "100%", height: "100%", position: "relative",
                  background: "linear-gradient(135deg, #1A4A7A 0%, #6E4A9C 60%, #C36B7B 100%)",
                  overflow: "hidden", fontFamily: "var(--font-family)" }}>
      {/* Wallpaper aesthetic */}
      <svg style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
        <defs>
          <radialGradient id="wp1" cx="20%" cy="30%">
            <stop offset="0" stopColor="rgba(255,255,255,0.20)"/>
            <stop offset="1" stopColor="transparent"/>
          </radialGradient>
        </defs>
        <rect width="100%" height="100%" fill="url(#wp1)"/>
      </svg>

      {/* Menu bar */}
      <div style={{
        position: "absolute", top: 0, left: 0, right: 0,
        height: 28, background: "rgba(20,20,30,0.45)",
        backdropFilter: "blur(20px) saturate(180%)",
        display: "flex", alignItems: "center", padding: "0 16px", gap: 16,
        color: "#fff", fontSize: 12.5, zIndex: 5,
      }}>
        <span style={{ fontWeight: 700, fontSize: 14 }}></span>
        <span style={{ fontWeight: 700 }}>Tax Lien Galaxy</span>
        <span>File</span><span>Edit</span><span>View</span><span>Galaxy</span><span>Window</span><span>Help</span>
        <span style={{ flex: 1 }}/>
        <span style={{ position: "relative", display: "flex", alignItems: "center", gap: 4 }}>
          {Ico.bolt}
          <span style={{ position: "absolute", top: -3, right: -5, width: 6, height: 6, borderRadius: "50%", background: COLORS.danger, border: "1.5px solid rgba(20,20,30,0.85)" }}/>
        </span>
        <span>Wi-Fi</span>
        <span>74%</span>
        <span style={{ display: "inline-flex", alignItems: "center", gap: 4 }}>
          <span style={{
            width: 22, height: 22, borderRadius: 4,
            background: "var(--brand-gradient)", color: "#fff",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.galaxy}</span>
        </span>
        <span style={{ fontWeight: 600 }}>Fri 9:41</span>
      </div>

      {/* Tray dropdown popup */}
      <div style={{
        position: "absolute", top: 36, right: 76, width: 380,
        background: "rgba(245,245,250,0.92)",
        backdropFilter: "blur(60px) saturate(180%)",
        border: "0.5px solid rgba(255,255,255,0.6)",
        borderRadius: 14, padding: 14,
        boxShadow: "0 32px 80px rgba(0,0,0,0.40)",
        color: COLORS.fg1, fontSize: 13,
      }}>
        {/* arrow */}
        <div style={{
          position: "absolute", top: -6, right: 28,
          width: 12, height: 12, borderRadius: 2,
          background: "rgba(245,245,250,0.92)",
          transform: "rotate(45deg)", borderLeft: "0.5px solid rgba(255,255,255,0.6)",
          borderTop: "0.5px solid rgba(255,255,255,0.6)",
        }}/>

        {/* header */}
        <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
          <div style={{
            width: 32, height: 32, borderRadius: 8,
            background: "var(--brand-gradient)", color: "#fff",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.galaxy}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 700 }}>Tax Lien Galaxy</div>
            <div style={{ fontSize: 11, color: COLORS.fg2 }}>Watching 14 liens · live</div>
          </div>
          <div style={{ display: "inline-flex", alignItems: "center", gap: 4, padding: "3px 8px",
                        background: COLORS.success+"1c", color: COLORS.success, borderRadius: 999, fontSize: 10, fontWeight: 700 }}>
            <span style={{ width: 5, height: 5, borderRadius: "50%", background: "currentColor", animation: "pulse 1.5s infinite" }}/>
            Connected
          </div>
        </div>

        {/* portfolio quick stat */}
        <div style={{ padding: 10, background: "rgba(0,91,234,0.06)", borderRadius: 10, marginBottom: 12 }}>
          <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between" }}>
            <span style={{ fontSize: 11, color: COLORS.brand, fontWeight: 700, textTransform: "uppercase", letterSpacing: 0.06 }}>Portfolio</span>
            <span style={{ fontSize: 10, color: COLORS.success, fontWeight: 600 }}>+$4,830 30d</span>
          </div>
          <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.01, marginTop: 2 }}>$184,200</div>
        </div>

        {/* Live alerts */}
        <div style={{ fontSize: 10, color: COLORS.fg2, fontWeight: 700, textTransform: "uppercase", letterSpacing: 0.06, marginBottom: 6 }}>Live</div>
        {[
          { ic: Ico.warn, c: COLORS.danger, t: "Maricopa auction · 30 min", s: "142 liens · 18% max" },
          { ic: Ico.trend, c: COLORS.success, t: "1247 Oak St redeemed", s: "Earned $1,994 · 16% APR" },
          { ic: Ico.ai, c: COLORS.brand, t: "4 Flipper matches · Duval, FL", s: "Avg 22% ROI" },
        ].map((n, i) => (
          <div key={i} style={{
            display: "flex", gap: 10, padding: "8px 6px", borderRadius: 8,
            cursor: "pointer",
          }}>
            <div style={{ width: 26, height: 26, borderRadius: 6, background: n.c+"1c", color: n.c,
                          display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>{n.ic}</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 12.5, fontWeight: 600 }}>{n.t}</div>
              <div style={{ fontSize: 11, color: COLORS.fg2, lineHeight: 1.3 }}>{n.s}</div>
            </div>
          </div>
        ))}

        <hr className="divider"/>

        {/* Actions */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 4 }}>
          {[
            { ic: Ico.galaxy, k: "Open Galaxy", shortcut: "⌘1" },
            { ic: Ico.search, k: "Quick search", shortcut: "⌘K" },
            { ic: Ico.layers, k: "Pipeline",     shortcut: "⌘2" },
            { ic: Ico.ai,     k: "Ask AI",       shortcut: "⌥A" },
          ].map(it => (
            <div key={it.k} style={{
              display: "flex", alignItems: "center", gap: 8, padding: "8px 8px",
              borderRadius: 6, fontSize: 12,
            }}>
              <span style={{ color: COLORS.fg2 }}>{it.ic}</span>
              <span style={{ flex: 1 }}>{it.k}</span>
              <span style={{ fontSize: 10, color: COLORS.fg2, fontFamily: "monospace", padding: "1px 5px", background: "rgba(48,63,73,0.06)", borderRadius: 3 }}>{it.shortcut}</span>
            </div>
          ))}
        </div>

        <hr className="divider"/>

        {/* Status row */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", fontSize: 11, color: COLORS.fg2 }}>
          <span>Data freshness · 14m ago</span>
          <span style={{ color: COLORS.brand, fontWeight: 600, cursor: "pointer" }}>Preferences…</span>
        </div>
      </div>

      {/* Faded background apps */}
      <div style={{
        position: "absolute", left: 36, top: 100, width: 500, height: 320,
        borderRadius: 12, background: "rgba(255,255,255,0.65)",
        backdropFilter: "blur(20px)", border: "0.5px solid rgba(255,255,255,0.4)",
        boxShadow: "0 30px 80px rgba(0,0,0,0.25)",
      }}>
        <div style={{ height: 30, background: "rgba(255,255,255,0.5)", borderRadius: "12px 12px 0 0",
                      display: "flex", alignItems: "center", padding: "0 12px", gap: 8 }}>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#FF5F57", border: "0.5px solid rgba(0,0,0,0.1)" }}/>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#FEBC2E", border: "0.5px solid rgba(0,0,0,0.1)" }}/>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#28C840", border: "0.5px solid rgba(0,0,0,0.1)" }}/>
          <span style={{ flex: 1, textAlign: "center", fontSize: 12, color: COLORS.fg1, fontWeight: 500 }}>Galaxy</span>
        </div>
        <div style={{ padding: 16, opacity: 0.55 }}>
          <div style={{ fontSize: 14, fontWeight: 700, marginBottom: 4 }}>847 properties</div>
          <div style={{ fontSize: 11, color: COLORS.fg2 }}>Galaxy active in background</div>
        </div>
      </div>

      <style>{`@keyframes pulse { 0%,100% { opacity: 1 } 50% { opacity: 0.3 } }`}</style>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 5. AR concept — iPad Pro w/ camera passthrough
// ──────────────────────────────────────────────────────────────────
function DesktopARConcept() {
  return (
    <div style={{ width: "100%", height: "100%", position: "relative",
                  background: "#1A1A20", overflow: "hidden", fontFamily: "var(--font-family)" }}>
      {/* faux conference room background */}
      <svg viewBox="0 0 1440 860" preserveAspectRatio="xMidYMid slice" style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
        <defs>
          <linearGradient id="floor" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0" stopColor="#3A3530"/>
            <stop offset="1" stopColor="#1C1A18"/>
          </linearGradient>
          <linearGradient id="wall" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0" stopColor="#5A5450"/>
            <stop offset="1" stopColor="#2C2825"/>
          </linearGradient>
        </defs>
        <rect width="1440" height="500" fill="url(#wall)"/>
        <polygon points="0,500 1440,500 1440,860 0,860" fill="url(#floor)"/>
        {/* table */}
        <polygon points="200,540 1240,540 1340,820 100,820" fill="#5C4A38"/>
        <polygon points="200,540 1240,540 1240,560 200,560" fill="#3A2C20"/>
        {/* window light */}
        <rect x="180" y="100" width="220" height="280" fill="rgba(255,247,220,0.25)"/>
      </svg>

      {/* AR holographic property cards "floating" on the table */}
      {[
        { x: 280, y: 380, w: 200, h: 280, addr: "1247 Oak St",   tax: "$12.5k", roi: "18%", g: "A", z: 1 },
        { x: 580, y: 360, w: 240, h: 320, addr: "2840 Hilltop",  tax: "$18.0k", roi: "22%", g: "A", z: 2 },
        { x: 920, y: 380, w: 200, h: 280, addr: "5602 Palm Ave", tax: "$7.8k",  roi: "14%", g: "B", z: 1 },
      ].map((c, i) => (
        <div key={i} style={{
          position: "absolute", left: c.x, top: c.y, width: c.w, height: c.h,
          background: "rgba(0,91,234,0.10)",
          backdropFilter: "blur(8px)", WebkitBackdropFilter: "blur(8px)",
          border: `1.5px solid ${COLORS.cyan}`,
          borderRadius: 14,
          boxShadow: `0 0 60px ${COLORS.cyan}66, inset 0 0 30px rgba(0,198,251,0.12)`,
          padding: 16, color: "#fff",
          transform: `perspective(1200px) rotateX(${i === 1 ? 0 : (i === 0 ? -8 : 8)}deg) translateZ(${c.z*10}px)`,
          fontFamily: "var(--font-family)",
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 12 }}>
            <GradeBadge grade={c.g}/>
            <Badge tone="cyan" style={{ background: "rgba(0,198,251,0.30)", color: "#fff" }}>HOLO</Badge>
          </div>
          <div style={{ height: 80, borderRadius: 8, background: "rgba(255,255,255,0.10)",
                        border: "1px solid rgba(0,198,251,0.3)", marginBottom: 12,
                        display: "flex", alignItems: "center", justifyContent: "center", fontSize: 30 }}>🏠</div>
          <div style={{ fontSize: 14, fontWeight: 700 }}>{c.addr}</div>
          <div style={{ display: "flex", justifyContent: "space-between", marginTop: 10 }}>
            <div>
              <div style={{ fontSize: 9, color: "rgba(255,255,255,0.55)", fontWeight: 700, letterSpacing: 0.06 }}>TAX</div>
              <div style={{ fontSize: 13, fontWeight: 700 }}>{c.tax}</div>
            </div>
            <div>
              <div style={{ fontSize: 9, color: "rgba(255,255,255,0.55)", fontWeight: 700, letterSpacing: 0.06 }}>ROI</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: COLORS.success }}>{c.roi}</div>
            </div>
          </div>
          {/* base shadow */}
          <div style={{ position: "absolute", left: "10%", right: "10%", bottom: -16, height: 12,
                        background: "radial-gradient(ellipse, rgba(0,198,251,0.4) 0%, transparent 70%)",
                        filter: "blur(4px)" }}/>
        </div>
      ))}

      {/* connection lines between cards */}
      <svg style={{ position: "absolute", inset: 0, pointerEvents: "none" }} viewBox="0 0 1440 860">
        <line x1="480" y1="500" x2="580" y2="500" stroke={COLORS.cyan} strokeWidth="2" strokeDasharray="6 4" opacity="0.5"/>
        <line x1="820" y1="500" x2="920" y2="500" stroke={COLORS.cyan} strokeWidth="2" strokeDasharray="6 4" opacity="0.5"/>
      </svg>

      {/* User's hand reaching in */}
      <svg viewBox="0 0 200 200" style={{ position: "absolute", left: 600, top: 580, width: 180, height: 180 }}>
        <path d="M 60 180 Q 50 120, 80 80 Q 100 60, 110 100 Q 120 60, 130 80 Q 140 60, 145 110 Q 150 130, 130 180 Z" fill="rgba(220,180,160,0.85)"/>
        <ellipse cx="105" cy="78" rx="8" ry="14" fill="rgba(255,255,255,0.5)"/>
      </svg>

      {/* HUD overlay (corners) */}
      <div style={{
        position: "absolute", top: 24, left: 24,
        padding: 14, borderRadius: 12, color: "#fff",
        background: "rgba(15,16,36,0.55)", backdropFilter: "blur(20px)",
        border: `1px solid ${COLORS.cyan}55`,
      }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          <span style={{ width: 8, height: 8, borderRadius: "50%", background: COLORS.cyan, animation: "pulse 1.5s infinite" }}/>
          <span style={{ fontSize: 10, fontWeight: 700, letterSpacing: 0.08, color: COLORS.cyan }}>AR MODE · BETA</span>
        </div>
        <div style={{ fontSize: 14, fontWeight: 700, marginTop: 6 }}>3 properties anchored</div>
        <div style={{ fontSize: 11, color: "rgba(255,255,255,0.6)", marginTop: 4 }}>Tap any holo to expand · pinch to group · two-hand pull to spread</div>
      </div>

      <div style={{
        position: "absolute", top: 24, right: 24, color: "#fff",
        padding: 14, borderRadius: 12,
        background: "rgba(15,16,36,0.55)", backdropFilter: "blur(20px)",
        border: `1px solid ${COLORS.success}55`,
      }}>
        <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: 0.08, color: COLORS.success }}>SCENE</div>
        <div style={{ fontSize: 13, marginTop: 6, lineHeight: 1.4 }}>
          Hilltop Dr is the strongest pick. Tap to <b>drag</b> into the room and place permanently.
        </div>
      </div>

      <style>{`@keyframes pulse { 0%,100% { opacity: 1 } 50% { opacity: 0.3 } }`}</style>
    </div>
  );
}

Object.assign(window, {
  DesktopCommandCenter, DesktopKanbanScreen, Desktop3DCubeScreen,
  DesktopTrayScreen, DesktopARConcept, NavGroup,
});
