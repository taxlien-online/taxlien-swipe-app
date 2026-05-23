// mechanics-phone.jsx — futuristic gesture mechanics on phone:
// layered card, orbit favorites, magnetic groups, AI loupe,
// command palette, voice+gesture, map layers, tax radar, tax graph.

// ──────────────────────────────────────────────────────────────────
// 1. Document as layered card — stack peeking up from bottom
// ──────────────────────────────────────────────────────────────────
function LayeredCardScreen() {
  const layers = [
    { id: 5, title: "Risk analysis",  sub: "ML scores + comparable redemption history", color: COLORS.danger, accent: "rgba(229,72,77,0.06)" },
    { id: 4, title: "Edit history",   sub: "5 changes · last by County of Maricopa", color: COLORS.purple, accent: "rgba(123,91,234,0.06)" },
    { id: 3, title: "Connections",    sub: "Linked auction · 2 prior owners · 3 satellites", color: COLORS.brand, accent: "rgba(0,91,234,0.06)" },
    { id: 2, title: "Tax parameters", sub: "Issue date · rate · subsequent taxes · expiration", color: COLORS.warning, accent: "rgba(255,176,32,0.08)" },
    { id: 1, title: "Items & valuation", sub: "Building + land breakdown · improvements list", color: COLORS.success, accent: "rgba(31,182,122,0.07)" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Property" sub="Stack · swipe down to dig"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="xray" accent>{Ico.xray}</IconButton>}
      />
      <div style={{ flex: 1, position: "relative", padding: "0 16px", overflow: "hidden" }}>
        {/* Top — main card pinned at top */}
        <div className="surface-card" style={{
          padding: 14, position: "relative", zIndex: 10,
          boxShadow: "0 12px 32px rgba(20,35,50,0.10), var(--shadow-card)",
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
            <GradeBadge grade="A" size="md"/>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 16, fontWeight: 700 }}>1247 Oak Street</div>
              <div style={{ fontSize: 11, color: COLORS.fg2 }}>Maricopa · 123-45-678 · LIEN</div>
            </div>
            <Badge tone="info">LISTED</Badge>
          </div>
          <div style={{ display: "flex", gap: 6 }}>
            <StatTile label="Lien" value="$12,450" accent={COLORS.brand}/>
            <StatTile label="ROI" value="18.5%" accent={COLORS.success}/>
            <StatTile label="FVI" value="8.2"/>
          </div>
        </div>

        {/* Stack illustration */}
        <div style={{
          position: "absolute", left: 16, right: 16,
          top: 140, bottom: 12,
        }}>
          {layers.map((l, i) => {
            const fromTop = i * 26;
            const cardWidth = 100 - i * 5;  // %
            return (
              <div key={l.id} style={{
                position: "absolute", top: fromTop,
                left: `${(100 - cardWidth)/2}%`, width: `${cardWidth}%`,
                background: "#fff",
                borderRadius: 14, padding: "10px 12px",
                boxShadow: "0 -6px 18px rgba(20,35,50,0.08), 0 0 0 1px var(--line)",
                zIndex: 10 - i, height: 110,
                overflow: "hidden", display: "flex", flexDirection: "column", gap: 4,
              }}>
                <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                  <div style={{
                    fontSize: 9, fontWeight: 700, padding: "2px 6px",
                    background: l.accent, color: l.color, borderRadius: 4,
                    letterSpacing: 0.05, textTransform: "uppercase",
                  }}>Layer {l.id}</div>
                  <div style={{ fontSize: 13, fontWeight: 600, color: COLORS.fg1 }}>{l.title}</div>
                </div>
                <div style={{ fontSize: 11, color: COLORS.fg2, lineHeight: 1.35 }}>{l.sub}</div>
                <div style={{
                  marginTop: "auto", height: 18, borderRadius: 4,
                  background: `linear-gradient(90deg, ${l.color}33, transparent)`,
                }}/>
              </div>
            );
          })}
        </div>

        {/* gesture hint */}
        <div style={{
          position: "absolute", right: 22, top: 200, zIndex: 20,
          padding: "8px 10px", borderRadius: 999,
          background: "rgba(15,20,25,0.85)", color: "#fff",
          fontSize: 11, fontWeight: 500,
          display: "flex", alignItems: "center", gap: 6,
        }}>
          <svg width="12" height="14" viewBox="0 0 12 14">
            <path d="M6 1v8M3 6l3 3 3-3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none"/>
          </svg>
          Swipe down to dive
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 2. Orbit favorites — radial drop zones
// ──────────────────────────────────────────────────────────────────
function OrbitFavoritesScreen() {
  // Orbits (drop targets around central card)
  const orbits = [
    { angle: -90, label: "Watchlist",  count: 24, color: COLORS.brand,   icon: Ico.heartF },
    { angle: -30, label: "To review",  count: 8,  color: COLORS.warning, icon: Ico.search },
    { angle: 30,  label: "Urgent",     count: 3,  color: COLORS.danger,  icon: Ico.bolt },
    { angle: 90,  label: "Disputed",   count: 1,  color: COLORS.purple,  icon: Ico.warn },
    { angle: 150, label: "To attorney", count: 2,  color: COLORS.fg1,    icon: Ico.shield },
    { angle: 210, label: "Archive",    count: 47, color: COLORS.fg2,    icon: Ico.refresh },
  ];

  const cx = 50, cy = 56, r = 30;
  const rad = (a) => (a * Math.PI) / 180;

  return (
    <PhoneScreen>
      <TopBar title="Triage" sub="Flick to send · long-press to drop"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div style={{ flex: 1, position: "relative", padding: "0 16px", overflow: "hidden" }}>
        {/* orbit dial */}
        <svg viewBox="0 0 100 110" style={{
          position: "absolute", inset: 0, width: "100%", height: "100%",
          pointerEvents: "none",
        }}>
          {/* concentric rings */}
          {[20, 28].map(rr => (
            <circle key={rr} cx={cx} cy={cy} r={rr} stroke="var(--line)"
                    strokeWidth="0.3" fill="none" strokeDasharray="0.8 0.8"/>
          ))}
          {/* radial segments */}
          {orbits.map((o, i) => {
            const a1 = rad(o.angle - 30);
            const a2 = rad(o.angle + 30);
            const x1 = cx + Math.cos(a1) * 16, y1 = cy + Math.sin(a1) * 16;
            const x2 = cx + Math.cos(a2) * 16, y2 = cy + Math.sin(a2) * 16;
            return <path key={i} d={`M ${cx} ${cy} L ${x1} ${y1} A 16 16 0 0 1 ${x2} ${y2} Z`} fill={o.color} opacity="0.04"/>;
          })}
        </svg>

        {/* labels positioned around */}
        {orbits.map((o, i) => {
          const x = cx + Math.cos(rad(o.angle)) * r;
          const y = cy + Math.sin(rad(o.angle)) * r;
          return (
            <div key={i} style={{
              position: "absolute", left: `${x}%`, top: `${y}%`,
              transform: "translate(-50%, -50%)",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 4,
            }}>
              <div style={{
                width: 52, height: 52, borderRadius: "50%",
                background: o.color + "16", color: o.color,
                border: `1.5px dashed ${o.color}`,
                display: "flex", alignItems: "center", justifyContent: "center",
                position: "relative",
              }}>{o.icon}
                {o.count > 0 && (
                  <span style={{
                    position: "absolute", top: -4, right: -4,
                    minWidth: 18, height: 18, borderRadius: 9,
                    background: o.color, color: "#fff", fontSize: 10, fontWeight: 700,
                    padding: "0 4px", display: "flex", alignItems: "center", justifyContent: "center",
                  }}>{o.count}</span>
                )}
              </div>
              <div style={{ fontSize: 10, fontWeight: 600, color: COLORS.fg1,
                            background: "rgba(255,255,255,0.85)", padding: "1px 5px", borderRadius: 4 }}>
                {o.label}
              </div>
            </div>
          );
        })}

        {/* center floating card (the one being moved) */}
        <div style={{
          position: "absolute", left: "50%", top: "56%",
          transform: "translate(-50%, -50%) rotate(-3deg)",
          width: 160,
          background: "#fff", borderRadius: 12,
          boxShadow: "0 14px 36px rgba(0,91,234,0.25), 0 0 0 2px var(--brand-blue)",
          padding: 10, zIndex: 5,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 4 }}>
            <GradeBadge grade="A" size="sm"/>
            <Badge tone="info">LIEN</Badge>
          </div>
          <div style={{ fontSize: 12, fontWeight: 700 }}>1247 Oak St</div>
          <div style={{ fontSize: 10, color: COLORS.fg2 }}>Maricopa · $12,450</div>
          <div style={{
            position: "absolute", bottom: -10, left: "50%", transform: "translateX(-50%)",
            width: 30, height: 30, borderRadius: "50%",
            background: "rgba(0,91,234,0.20)", border: "2px solid var(--brand-blue)",
          }}/>
        </div>

        {/* swipe vector arrows */}
        <svg viewBox="0 0 100 110" style={{ position: "absolute", inset: 0, width: "100%", height: "100%", pointerEvents: "none" }}>
          {[-90, -30].map(a => {
            const x1 = cx + Math.cos(rad(a)) * 12, y1 = cy + Math.sin(rad(a)) * 12;
            const x2 = cx + Math.cos(rad(a)) * 24, y2 = cy + Math.sin(rad(a)) * 24;
            return <path key={a} d={`M ${x1} ${y1} L ${x2} ${y2}`}
                         stroke="var(--brand-blue)" strokeWidth="0.5" strokeDasharray="1.5 1.5"/>;
          })}
        </svg>
      </div>

      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 10, display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ flex: 1, fontSize: 12, color: COLORS.fg2 }}>
            <div style={{ fontWeight: 600, color: COLORS.fg1, fontSize: 13 }}>Flick to send anywhere</div>
            <div>↑ Watchlist · → Urgent · ↓ Archive · ↖ To attorney · diagonal = disputed</div>
          </div>
        </div>
      </div>
      <BottomNav active="watchlist"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 3. Magnetic groups — properties pulled together by relation
// ──────────────────────────────────────────────────────────────────
function MagneticGroupsScreen() {
  // Three clusters by relation
  const clusters = [
    { cx: 28, cy: 32, label: "Owner: John K.", relation: "Same owner", count: 5, color: COLORS.brand },
    { cx: 70, cy: 38, label: "Oak Street", relation: "Same street", count: 4, color: COLORS.success },
    { cx: 50, cy: 70, label: "$12k ± 5%", relation: "Similar amount", count: 7, color: COLORS.warning },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Magnetic groups" sub="Drag two together to see relation"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="more">{Ico.more}</IconButton>}
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.brand }}/>
          {Ico.link}<span>Magnets on</span>
        </div>

        {/* clusters */}
        {clusters.map((c, ci) => (
          <React.Fragment key={ci}>
            {/* magnetic field rings */}
            {[1.2, 1.8].map(s => (
              <div key={s} style={{
                position: "absolute", left: `${c.cx}%`, top: `${c.cy}%`,
                width: 50*s, height: 50*s, borderRadius: "50%",
                transform: "translate(-50%, -50%)",
                background: `radial-gradient(circle, ${c.color}${s===1.2?"22":"12"} 0%, transparent 70%)`,
                pointerEvents: "none",
              }}/>
            ))}
            {/* connections */}
            {[0,1,2,3].map(k => {
              const phi = (k / 4) * Math.PI * 2 + ci * 0.7;
              const r = 9;
              const px = c.cx + Math.cos(phi) * r;
              const py = c.cy + Math.sin(phi) * r * 1.1;
              return (
                <React.Fragment key={k}>
                  <svg style={{ position: "absolute", inset: 0, width: "100%", height: "100%", pointerEvents: "none" }}
                       viewBox="0 0 100 100" preserveAspectRatio="none">
                    <line x1={c.cx} y1={c.cy} x2={px} y2={py} stroke={c.color}
                          strokeWidth="0.15" strokeDasharray="0.6 0.6" opacity="0.5"/>
                  </svg>
                  <GalaxyDot x={px} y={py} size={8} color={c.color}/>
                </React.Fragment>
              );
            })}
            {/* cluster center label */}
            <div style={{
              position: "absolute", left: `${c.cx}%`, top: `${c.cy}%`,
              transform: "translate(-50%, -50%)",
              background: c.color, color: "#fff",
              padding: "5px 10px", borderRadius: 999,
              fontSize: 10, fontWeight: 700,
              boxShadow: `0 4px 14px ${c.color}55`,
              display: "flex", alignItems: "center", gap: 4,
              whiteSpace: "nowrap",
            }}>
              <span style={{ fontSize: 12, fontWeight: 800 }}>{c.count}</span>
              {c.label}
            </div>
          </React.Fragment>
        ))}
      </div>

      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 12 }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Relation strength</div>
          <div style={{ display: "flex", gap: 6, marginTop: 8, flexWrap: "wrap" }}>
            <Badge tone="info">Same owner · 5</Badge>
            <Badge tone="good">Same street · 4</Badge>
            <Badge tone="warn">Similar amount · 7</Badge>
            <Badge tone="purple">Same auction · 3</Badge>
            <Badge tone="neutral">Same tax year · 12</Badge>
          </div>
          <hr className="divider"/>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <div style={{ fontSize: 12, color: COLORS.fg1, flex: 1 }}>
              <div style={{ fontWeight: 600 }}>2 strong matches detected</div>
              <div style={{ color: COLORS.fg2 }}>Both properties at 1247 Oak St have same owner since 2018</div>
            </div>
            <button className="cta" style={{ padding: "8px 12px", fontSize: 12 }}>Investigate</button>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 4. AI Loupe — circular magnifier with on-the-fly explanations
// ──────────────────────────────────────────────────────────────────
function AILoupeScreen() {
  return (
    <PhoneScreen>
      <TopBar title="Property" sub="Hold and drag the loupe"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <div style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            padding: "6px 10px", borderRadius: 999,
            background: "var(--brand-gradient)", color: "#fff",
            fontSize: 11, fontWeight: 700, letterSpacing: 0.06,
          }}>
            {Ico.search} AI LOUPE
          </div>
        }
      />
      <div style={{ flex: 1, padding: "0 16px 12px", position: "relative" }}>
        <PropertyImage height={130} tone="cool"/>
        <div className="surface-card" style={{ padding: 14, marginTop: 10 }}>
          <div style={{ fontSize: 16, fontWeight: 700 }}>1247 Oak Street</div>
          <div style={{ fontSize: 12, color: COLORS.fg2 }}>Maricopa · 123-45-678</div>
          <div style={{ display: "flex", gap: 6, marginTop: 10 }}>
            <StatTile label="Tax" value="$12,450" sub="vs $4,800 avg" accent={COLORS.warning}/>
            <StatTile label="Value" value="$89,000"/>
            <StatTile label="ROI" value="18.5%" accent={COLORS.success}/>
          </div>
          <div style={{ display: "flex", gap: 6, marginTop: 8 }}>
            <StatTile label="Owner" value="John K." sub="since 2018"/>
            <StatTile label="Rate" value="16%"/>
            <StatTile label="Years" value="3" sub="delinquent" accent={COLORS.danger}/>
          </div>
        </div>

        {/* Loupe overlay positioned over the Tax tile */}
        <div style={{
          position: "absolute", left: 28, top: 178,
          width: 130, height: 130, borderRadius: "50%",
          border: `2.5px solid ${COLORS.brand}`,
          background: "rgba(0,91,234,0.04)",
          boxShadow: "0 8px 32px rgba(0,91,234,0.25), inset 0 0 0 4px rgba(255,255,255,0.9), 0 0 0 12px rgba(0,91,234,0.05)",
          pointerEvents: "none",
        }}>
          {/* magnification crosshair */}
          <svg viewBox="0 0 130 130" width="130" height="130">
            <line x1="65" y1="55" x2="65" y2="75" stroke={COLORS.brand} strokeWidth="0.6" opacity="0.5"/>
            <line x1="55" y1="65" x2="75" y2="65" stroke={COLORS.brand} strokeWidth="0.6" opacity="0.5"/>
            <text x="65" y="55" textAnchor="middle" fontSize="16" fontWeight="800" fill={COLORS.warning}>$12,450</text>
            <text x="65" y="72" textAnchor="middle" fontSize="9" fill={COLORS.fg2} fontWeight="600">2.6× COUNTY AVG</text>
          </svg>
          {/* handle */}
          <div style={{
            position: "absolute", right: -10, bottom: -10,
            width: 16, height: 50, borderRadius: 8,
            background: COLORS.brand,
            transform: "rotate(-45deg)",
            transformOrigin: "top left",
          }}/>
        </div>

        {/* AI bubble */}
        <div style={{
          position: "absolute", right: 14, top: 210,
          width: 220, padding: 12, borderRadius: 14,
          background: "var(--surface)",
          boxShadow: "0 12px 36px rgba(20,35,50,0.18), 0 0 0 1px var(--line)",
          zIndex: 5,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 6 }}>
            <div style={{
              width: 22, height: 22, borderRadius: "50%",
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.ai}</div>
            <span style={{ fontSize: 10, fontWeight: 700, color: COLORS.brand, letterSpacing: 0.06, textTransform: "uppercase" }}>AI loupe</span>
          </div>
          <div style={{ fontSize: 13, color: COLORS.fg1, lineHeight: 1.4 }}>
            Tax amount is <b>2.6×</b> the Maricopa median for similar-value parcels.
          </div>
          <div style={{ fontSize: 11, color: COLORS.fg2, marginTop: 6, lineHeight: 1.4 }}>
            Likely cause: 3 prior unpaid years stacked on this parcel. Each year compounds penalties at 16%. Strong distress signal.
          </div>
          <div style={{ display: "flex", gap: 4, marginTop: 8 }}>
            <Badge tone="hot">Anomaly</Badge>
            <Badge tone="info">3yr stack</Badge>
          </div>
        </div>

        {/* hint */}
        <div style={{
          position: "absolute", left: "50%", bottom: 64,
          transform: "translateX(-50%)",
          padding: "6px 12px", borderRadius: 999,
          background: "rgba(15,20,25,0.85)", color: "#fff",
          fontSize: 11, fontWeight: 500,
        }}>
          Drag loupe over any field
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 5. Command palette — 3-finger pull-down
// ──────────────────────────────────────────────────────────────────
function CommandPaletteScreen() {
  const cmds = [
    { icon: Ico.search,  k: "Find liens by John K.",          hint: "owner search", color: COLORS.brand },
    { icon: Ico.warn,    k: "Show overdue 3+ years",          hint: "preset",      color: COLORS.danger },
    { icon: Ico.trend,   k: "ROI > 20% in Florida",           hint: "AI query",    color: COLORS.success },
    { icon: Ico.scale,   k: "Compare 1247 Oak vs 5602 Palm",  hint: "bridge",      color: COLORS.warning },
    { icon: Ico.heart,   k: "Add selection to Watchlist",     hint: "14 selected", color: COLORS.danger },
    { icon: Ico.link,    k: "Export selection as CSV",        hint: "ELITE only",  color: COLORS.purple, locked: true },
    { icon: Ico.cal,     k: "Auctions next 7 days",           hint: "temporal",    color: COLORS.warning },
    { icon: Ico.refresh, k: "Refresh Pima County data",       hint: "manual sync", color: COLORS.fg2 },
  ];
  const points = layoutFor("roi");

  return (
    <PhoneScreen>
      {/* dim background */}
      <div style={{ position: "absolute", inset: 0, opacity: 0.35, filter: "blur(2px)" }}>
        <TopBar title="Galaxy" sub="847 properties"/>
        <div className="galaxy">
          {points.map(p => <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*0.7} color={p.color}/>)}
        </div>
      </div>
      <div style={{ position: "absolute", inset: 0, background: "rgba(15,20,25,0.45)" }}/>

      {/* palette */}
      <div style={{
        position: "absolute", left: 14, right: 14, top: 80, zIndex: 10,
        background: "rgba(255,255,255,0.96)",
        backdropFilter: "blur(40px) saturate(180%)",
        borderRadius: 18, padding: 14,
        boxShadow: "0 24px 60px rgba(20,35,50,0.30)",
      }}>
        <div style={{
          display: "flex", alignItems: "center", gap: 10,
          background: "var(--bg)", padding: "10px 12px",
          borderRadius: 10, border: `1.5px solid ${COLORS.brand}66`,
        }}>
          <span style={{ color: COLORS.brand }}>{Ico.search}</span>
          <span style={{ fontSize: 15, color: COLORS.fg1, flex: 1 }}>
            roi
            <span style={{ display: "inline-block", width: 1, height: 14, background: COLORS.brand, marginLeft: 2, verticalAlign: "middle", animation: "blink 1s steps(2) infinite" }}/>
          </span>
          <span style={{ fontSize: 10, color: COLORS.fg2, padding: "2px 6px", background: "rgba(48,63,73,0.08)", borderRadius: 4, fontFamily: "monospace" }}>⌘K</span>
        </div>

        <div style={{ marginTop: 8 }}>
          {cmds.map((c, i) => (
            <div key={i} style={{
              display: "flex", alignItems: "center", gap: 10, padding: "10px 8px",
              borderRadius: 8,
              background: i === 0 ? "rgba(0,91,234,0.06)" : "transparent",
            }}>
              <div style={{
                width: 28, height: 28, borderRadius: 6,
                background: c.color + "1c", color: c.color,
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>{c.icon}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13.5, color: COLORS.fg1, fontWeight: 500, opacity: c.locked ? 0.6 : 1 }}>{c.k}</div>
              </div>
              <div style={{ fontSize: 10, color: c.locked ? COLORS.purple : COLORS.fg2, fontWeight: 600 }}>
                {c.locked && <span style={{ background: COLORS.purple+"22", padding: "2px 6px", borderRadius: 4, marginRight: 4 }}>ELITE</span>}
                {c.hint}
              </div>
            </div>
          ))}
        </div>

        <div style={{
          marginTop: 8, padding: "10px 8px 0",
          borderTop: "1px solid var(--line)",
          display: "flex", justifyContent: "space-between",
          fontSize: 10, color: COLORS.fg2,
        }}>
          <span><kbd style={kbd}>↑↓</kbd> navigate · <kbd style={kbd}>↵</kbd> run</span>
          <span>3-finger ↓ to open · esc to close</span>
        </div>
      </div>
      <style>{`@keyframes blink { 50% { opacity: 0; } }`}</style>
    </PhoneScreen>
  );
}
const kbd = {
  display: "inline-block", padding: "1px 5px", margin: "0 1px",
  background: "rgba(48,63,73,0.08)", borderRadius: 4,
  fontFamily: "monospace", fontSize: 9, color: "#303F49",
};

// ──────────────────────────────────────────────────────────────────
// 6. Voice + gesture — listening while user has a lasso selection
// ──────────────────────────────────────────────────────────────────
function VoiceGestureScreen() {
  const points = layoutFor("roi");
  const selIds = new Set(points.filter((_,i) => i%5 === 1 || i%7 === 0).slice(0,18).map(p=>p.id));

  return (
    <PhoneScreen>
      <TopBar title="18 selected" sub="Listening for refinement…"
        leading={<button className="icon-btn">{Ico.close}</button>}
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.brand }}/>
          {Ico.trend}<span>ROI</span>
        </div>
        <div className="hud" style={{ top: 12, right: 12, color: COLORS.danger, fontWeight: 600 }}>
          <span style={{ width: 8, height: 8, borderRadius: "50%", background: COLORS.danger, animation: "blink 1.2s infinite" }}/>
          REC
        </div>

        {points.map(p => {
          const on = selIds.has(p.id);
          return (
            <GalaxyDot key={p.id} x={p.x} y={p.y}
                       size={on ? p.size*1.1 : p.size*0.85}
                       color={on ? p.color : COLORS.fg2}
                       opacity={on ? 1 : 0.18}
                       halo={on}/>
          );
        })}

        {/* selection halo */}
        <svg style={{ position: "absolute", inset: 0, pointerEvents: "none" }}
             viewBox="0 0 330 410" preserveAspectRatio="none">
          <path d="M 50 60 C 100 35, 220 30, 280 80 S 280 220, 200 230 S 60 180, 40 130 S 30 80, 50 60 Z"
                fill="rgba(0,91,234,0.05)" stroke={COLORS.brand}
                strokeWidth="1.6" strokeDasharray="5 3"/>
        </svg>
      </div>

      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 16,
              background: "linear-gradient(180deg, #fff 0%, #F6F9FC 100%)",
              border: `1.5px solid ${COLORS.brand}33` }}>
          {/* waveform */}
          <div style={{
            display: "flex", alignItems: "center", gap: 3, height: 36, marginBottom: 10,
          }}>
            {Array.from({length: 32}).map((_,i) => {
              const h = 4 + Math.abs(Math.sin(i*0.6) * 16) + (i%4)*4;
              return (
                <div key={i} style={{
                  flex: 1, height: h, borderRadius: 2,
                  background: i < 22 ? "var(--brand-gradient)" : "var(--fg-2)",
                  opacity: i < 22 ? 1 : 0.4,
                }}/>
              );
            })}
          </div>
          <div style={{ fontSize: 15, color: COLORS.fg1, lineHeight: 1.4 }}>
            "Keep only the deeds with prior years <span style={{ color: COLORS.brand, fontWeight: 600 }}>three or more</span>…"
            <span style={{ display: "inline-block", width: 1, height: 16, background: COLORS.brand, marginLeft: 2, verticalAlign: "middle", animation: "blink 1s steps(2) infinite" }}/>
          </div>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 10 }}>
            <div style={{ fontSize: 11, color: COLORS.fg2, display: "flex", alignItems: "center", gap: 6 }}>
              {Ico.mic} Hold and speak · release to apply
            </div>
            <div style={{ display: "flex", gap: 4 }}>
              <Badge tone="info">deed</Badge>
              <Badge tone="hot">3+ yr</Badge>
            </div>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
      <style>{`@keyframes blink { 50% { opacity: 0; } }`}</style>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 7. Map layers — geographic map with toggleable layers
// ──────────────────────────────────────────────────────────────────
function MapLayersScreen() {
  const layers = [
    { id: "props",  label: "Properties",   active: true,  color: COLORS.brand,   count: "847" },
    { id: "owners", label: "Owner clusters", active: false, color: COLORS.purple, count: "62" },
    { id: "risk",   label: "Risk heatmap",  active: true,  color: COLORS.danger,  count: "" },
    { id: "flood",  label: "Flood zones",   active: true,  color: COLORS.cyan,    count: "11 zones" },
    { id: "school", label: "School ratings", active: false, color: COLORS.success, count: "" },
    { id: "auct",   label: "Auction venues", active: true,  color: COLORS.warning, count: "8" },
    { id: "walk",   label: "Walkability",    active: false, color: COLORS.fg2,     count: "" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Map · Maricopa" sub="3 layers on"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="search">{Ico.search}</IconButton>}
      />
      <div style={{ flex: 1, position: "relative", overflow: "hidden", margin: "0 16px",
                    borderRadius: 14, background: "#E8EEF3" }}>
        {/* faux map */}
        <svg viewBox="0 0 330 460" preserveAspectRatio="none" style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
          {/* land */}
          <rect width="330" height="460" fill="#E8EEF3"/>
          {/* water */}
          <path d="M-10 50 Q 80 100, 50 200 T 0 380 L -10 460 L -10 50 Z" fill="#C5D8E8"/>
          <path d="M260 0 Q 320 120, 290 240 T 340 460 L 340 0 Z" fill="#C5D8E8"/>
          {/* streets */}
          {Array.from({length: 12}).map((_,i) => (
            <line key={"h"+i} x1="0" y1={40 + i*36} x2="330" y2={40 + i*36}
                  stroke="#fff" strokeWidth={i%4===0?"2":"0.8"} opacity={i%4===0?0.9:0.5}/>
          ))}
          {Array.from({length: 10}).map((_,i) => (
            <line key={"v"+i} x1={20 + i*32} y1="0" x2={20 + i*32} y2="460"
                  stroke="#fff" strokeWidth={i%3===0?"2":"0.8"} opacity={i%3===0?0.9:0.5}/>
          ))}
          {/* flood zones */}
          <path d="M40 80 Q 80 60, 120 90 T 200 100 L 180 160 Q 100 150, 50 130 Z" fill={COLORS.cyan} opacity="0.18"/>
          <path d="M180 300 Q 250 290, 280 330 L 270 380 Q 200 360, 180 340 Z" fill={COLORS.cyan} opacity="0.18"/>
          {/* risk heat */}
          <circle cx="140" cy="220" r="60" fill={COLORS.danger} opacity="0.14"/>
          <circle cx="140" cy="220" r="36" fill={COLORS.danger} opacity="0.20"/>
          <circle cx="220" cy="160" r="40" fill={COLORS.warning} opacity="0.18"/>
        </svg>

        {/* property pins */}
        {Array.from({length: 24}).map((_,i) => {
          const x = 20 + (i*53)%280;
          const y = 60 + (i*73)%360;
          const tone = i%5;
          const c = [COLORS.brand, COLORS.success, COLORS.warning, COLORS.danger, COLORS.cyan][tone];
          return (
            <div key={i} style={{
              position: "absolute", left: x, top: y,
              width: 14, height: 14, borderRadius: "50%",
              background: c, border: "2px solid #fff",
              boxShadow: "0 2px 6px rgba(0,0,0,0.2)",
              transform: "translate(-50%,-50%)",
            }}/>
          );
        })}

        {/* auction pin */}
        <div style={{
          position: "absolute", left: 160, top: 230,
          transform: "translate(-50%,-100%)",
          padding: "6px 10px", borderRadius: 8,
          background: COLORS.warning, color: "#fff",
          fontSize: 10, fontWeight: 700,
          boxShadow: "0 4px 12px rgba(255,176,32,0.4)",
        }}>
          ⚖ Phoenix Courthouse · Jun 15
          <div style={{
            position: "absolute", left: "50%", bottom: -4, transform: "translateX(-50%) rotate(45deg)",
            width: 8, height: 8, background: COLORS.warning,
          }}/>
        </div>

        {/* zoom controls */}
        <div style={{
          position: "absolute", right: 10, top: 10,
          display: "flex", flexDirection: "column", gap: 4,
          background: "#fff", borderRadius: 8, boxShadow: "var(--shadow-card)",
          padding: 4,
        }}>
          <div style={{ width: 28, height: 28, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 18, color: COLORS.fg1 }}>+</div>
          <div style={{ height: 1, background: "var(--line)" }}/>
          <div style={{ width: 28, height: 28, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 18, color: COLORS.fg1 }}>−</div>
        </div>
      </div>

      {/* layer panel */}
      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 12 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 8 }}>
            <span style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Layers</span>
            <span style={{ fontSize: 11, color: COLORS.brand, fontWeight: 600 }}>Manage →</span>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 6 }}>
            {layers.map(l => (
              <div key={l.id} style={{
                display: "flex", alignItems: "center", gap: 8, padding: "6px 8px",
                borderRadius: 8,
                background: l.active ? l.color + "12" : "transparent",
                border: l.active ? `1px solid ${l.color}55` : "1px solid var(--line)",
              }}>
                <div style={{ width: 10, height: 10, borderRadius: 2, background: l.color, opacity: l.active ? 1 : 0.3 }}/>
                <div style={{ flex: 1, fontSize: 12, fontWeight: 500, color: l.active ? COLORS.fg1 : COLORS.fg2 }}>{l.label}</div>
                {l.count && <span style={{ fontSize: 10, color: l.active ? l.color : COLORS.fg2, fontWeight: 600 }}>{l.count}</span>}
              </div>
            ))}
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 8. Tax Radar — hub-spoke around the user (your portfolio at center)
// ──────────────────────────────────────────────────────────────────
function TaxRadarScreen() {
  const center = { name: "Your portfolio", value: "$184k", liens: 14 };
  // counterparties at varying angles + distances (recency) + sizes (volume)
  const cps = [
    { angle: -90, dist: 0.55, name: "John K.",   sub: "5 liens · $42k", glow: COLORS.danger,  size: 14 },
    { angle: -55, dist: 0.65, name: "Acme Inc.", sub: "3 liens · $18k", glow: COLORS.warning, size: 11 },
    { angle: -20, dist: 0.42, name: "Sarah M.",  sub: "2 · redeemed",   glow: COLORS.success, size: 10 },
    { angle:  15, dist: 0.85, name: "Maricopa County", sub: "8 OTC available", glow: COLORS.brand,    size: 13 },
    { angle:  50, dist: 0.55, name: "Duval Tax Coll.", sub: "12 active", glow: COLORS.brand,    size: 12 },
    { angle:  90, dist: 0.74, name: "Heritage LLC", sub: "1 disputed",  glow: COLORS.purple,  size: 11 },
    { angle: 130, dist: 0.40, name: "Orange Co.",  sub: "6 listed",    glow: COLORS.cyan,     size: 10 },
    { angle: 175, dist: 0.62, name: "P. Davis",   sub: "3 · 1 senior", glow: COLORS.warning,  size: 11 },
    { angle: 215, dist: 0.45, name: "Bexar Co.",  sub: "4 listed",     glow: COLORS.brand,    size: 10 },
    { angle: 260, dist: 0.78, name: "Riverside Tr.", sub: "2 portfolio", glow: COLORS.success, size: 12 },
  ];

  const rad = (a) => (a * Math.PI) / 180;

  return (
    <PhoneScreen>
      <TopBar title="Tax Radar" sub="Live · 10 counterparties"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <div style={{
            display: "inline-flex", padding: "4px 8px", borderRadius: 999,
            background: COLORS.danger + "1c", color: COLORS.danger,
            fontSize: 10, fontWeight: 700, alignItems: "center", gap: 4,
          }}>
            <span style={{ width: 6, height: 6, borderRadius: "50%", background: COLORS.danger, animation: "pulse 1.5s infinite" }}/>
            LIVE
          </div>
        }
      />
      <div style={{ flex: 1, position: "relative", padding: "0 16px", overflow: "hidden" }}>
        <svg viewBox="0 0 100 110" style={{ width: "100%", height: "100%" }}>
          <defs>
            <radialGradient id="radarGrad">
              <stop offset="0" stopColor="#005BEA" stopOpacity="0.18"/>
              <stop offset="1" stopColor="#005BEA" stopOpacity="0"/>
            </radialGradient>
            <linearGradient id="sweepGrad" x1="0" y1="0" x2="1" y2="0">
              <stop offset="0" stopColor="#00C6FB" stopOpacity="0"/>
              <stop offset="1" stopColor="#00C6FB" stopOpacity="0.6"/>
            </linearGradient>
          </defs>
          {/* glow */}
          <circle cx="50" cy="55" r="44" fill="url(#radarGrad)"/>
          {/* rings */}
          {[14, 26, 38, 48].map(r => (
            <circle key={r} cx="50" cy="55" r={r} stroke="var(--line)" strokeWidth="0.2" fill="none"/>
          ))}
          {/* spokes */}
          {[0,45,90,135,180,225,270,315].map(a => {
            const x = 50 + Math.cos(rad(a-90)) * 48;
            const y = 55 + Math.sin(rad(a-90)) * 48;
            return <line key={a} x1="50" y1="55" x2={x} y2={y} stroke="var(--line)" strokeWidth="0.15"/>;
          })}
          {/* sweep wedge */}
          <path d={`M 50 55 L ${50 + Math.cos(rad(-90))*48} ${55 + Math.sin(rad(-90))*48} A 48 48 0 0 1 ${50 + Math.cos(rad(-30))*48} ${55 + Math.sin(rad(-30))*48} Z`}
                fill="url(#sweepGrad)" opacity="0.55"/>

          {/* counterparty dots */}
          {cps.map((c, i) => {
            const x = 50 + Math.cos(rad(c.angle)) * c.dist * 46;
            const y = 55 + Math.sin(rad(c.angle)) * c.dist * 46;
            return (
              <React.Fragment key={i}>
                <circle cx={x} cy={y} r={c.size/3.5} fill={c.glow} opacity="0.85"/>
                <circle cx={x} cy={y} r={c.size/3.5 + 1.2} stroke={c.glow} strokeWidth="0.3" fill="none" opacity="0.5"/>
              </React.Fragment>
            );
          })}

          {/* connection lines (you ↔ active dealings) */}
          {cps.filter((_,i)=>i<3).map((c, i) => {
            const x = 50 + Math.cos(rad(c.angle)) * c.dist * 46;
            const y = 55 + Math.sin(rad(c.angle)) * c.dist * 46;
            return <line key={i} x1="50" y1="55" x2={x} y2={y}
                         stroke={c.glow} strokeWidth="0.4" strokeDasharray="0.8 0.8" opacity="0.55"/>;
          })}

          {/* center */}
          <circle cx="50" cy="55" r="6" fill="url(#g1c)" stroke="#fff" strokeWidth="0.5"/>
          <defs>
            <radialGradient id="g1c"><stop offset="0" stopColor="#00C6FB"/><stop offset="1" stopColor="#005BEA"/></radialGradient>
          </defs>
        </svg>

        {/* labels for top 3 counterparties (HTML overlay) */}
        {cps.filter((_,i)=>i<3).map((c, i) => {
          const x = 50 + Math.cos(rad(c.angle)) * c.dist * 46;
          const y = 55 + Math.sin(rad(c.angle)) * c.dist * 46;
          return (
            <div key={i} style={{
              position: "absolute", left: `${x}%`, top: `${y + 4}%`,
              transform: "translate(-50%, 0)",
              fontSize: 9, padding: "2px 6px", borderRadius: 4,
              background: "rgba(255,255,255,0.9)", color: COLORS.fg1, fontWeight: 600,
              boxShadow: "var(--shadow-card)", whiteSpace: "nowrap",
            }}>{c.name}</div>
          );
        })}

        {/* center YOU label */}
        <div style={{
          position: "absolute", left: "50%", top: "59%",
          transform: "translate(-50%, 0)",
          fontSize: 9, fontWeight: 700, color: COLORS.brand,
          letterSpacing: 0.04,
        }}>YOU · $184k</div>
      </div>

      <div style={{ padding: "8px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 10, display: "flex", alignItems: "center", gap: 10 }}>
          <Badge tone="hot">John K. · ping</Badge>
          <div style={{ flex: 1, fontSize: 11, color: COLORS.fg2 }}>New lien filing detected · 18s ago</div>
          <button className="cta" style={{ padding: "6px 10px", fontSize: 11 }}>Open</button>
        </div>
      </div>
      <BottomNav active="galaxy"/>
      <style>{`@keyframes pulse { 0%,100% { opacity: 1 } 50% { opacity: 0.3 } }`}</style>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 9. Tax Graph — node-and-edge graph of connections
// ──────────────────────────────────────────────────────────────────
function TaxGraphScreen() {
  const W = 100, H = 100;
  const nodes = [
    { id: "you",    x: 50, y: 50, type: "you",      label: "YOU",         size: 12 },
    { id: "p1",     x: 30, y: 28, type: "property", label: "Oak St",      size: 8 },
    { id: "p2",     x: 70, y: 22, type: "property", label: "Palm Ave",    size: 8 },
    { id: "p3",     x: 75, y: 62, type: "property", label: "Hilltop",     size: 8 },
    { id: "p4",     x: 24, y: 70, type: "property", label: "Magnolia",    size: 8 },
    { id: "o1",     x: 12, y: 48, type: "owner",    label: "John K.",     size: 7 },
    { id: "o2",     x: 88, y: 42, type: "owner",    label: "Acme LLC",    size: 7 },
    { id: "c1",     x: 50, y: 16, type: "county",   label: "Maricopa",    size: 9 },
    { id: "c2",     x: 50, y: 84, type: "county",   label: "Duval",       size: 9 },
    { id: "a1",     x: 35, y: 88, type: "auction",  label: "Jun 15",      size: 6 },
    { id: "pay1",   x: 18, y: 32, type: "payment",  label: "$13.1k",      size: 6 },
    { id: "doc1",   x: 65, y: 80, type: "contract", label: "Deed 2023",   size: 6 },
  ];
  const edges = [
    ["you","p1"], ["you","p2"], ["you","p3"], ["you","p4"],
    ["p1","o1"], ["p4","o1"], ["p2","o2"], ["p3","o2"],
    ["p1","c1"], ["p2","c1"], ["p3","c2"], ["p4","c2"],
    ["p3","a1"], ["p1","pay1"], ["p3","doc1"], ["o1","o2"],
  ];
  const typeColor = {
    you: COLORS.brand, property: COLORS.success, owner: COLORS.warning,
    county: COLORS.purple, auction: COLORS.danger, payment: COLORS.cyan, contract: "#0EA5C7",
  };

  return (
    <PhoneScreen>
      <TopBar title="Tax graph" sub="12 entities · 16 edges"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <React.Fragment>
            <IconButton label="filter">{Ico.filter}</IconButton>
            <IconButton label="ai" accent>{Ico.ai}</IconButton>
          </React.Fragment>
        }
      />
      <div className="galaxy">
        <svg viewBox="0 0 100 100" style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
          {/* edges */}
          {edges.map(([a,b], i) => {
            const na = nodes.find(n=>n.id===a), nb = nodes.find(n=>n.id===b);
            return <line key={i} x1={na.x} y1={na.y} x2={nb.x} y2={nb.y}
                         stroke="var(--fg-2)" strokeWidth="0.25" opacity="0.45"/>;
          })}
          {/* nodes */}
          {nodes.map(n => (
            <React.Fragment key={n.id}>
              <circle cx={n.x} cy={n.y} r={n.size/2} fill={typeColor[n.type]}
                      stroke="#fff" strokeWidth="0.5"/>
              {n.id === "you" && (
                <circle cx={n.x} cy={n.y} r={n.size/2 + 2} stroke={typeColor[n.type]}
                        strokeWidth="0.4" fill="none" opacity="0.6"/>
              )}
            </React.Fragment>
          ))}
        </svg>
        {/* labels */}
        {nodes.map(n => (
          <div key={n.id} style={{
            position: "absolute", left: `${n.x}%`, top: `${n.y + n.size/2 + 1}%`,
            transform: "translate(-50%, 0)",
            fontSize: n.id === "you" ? 10 : 9,
            fontWeight: n.id === "you" ? 700 : 500,
            color: COLORS.fg1, padding: "1px 4px", borderRadius: 3,
            background: "rgba(255,255,255,0.85)",
            whiteSpace: "nowrap",
          }}>{n.label}</div>
        ))}
      </div>

      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 10 }}>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 8 }}>
            {Object.entries({Properties: COLORS.success, Owners: COLORS.warning, Counties: COLORS.purple, Auctions: COLORS.danger, Payments: COLORS.cyan, You: COLORS.brand}).map(([k,c]) => (
              <span key={k} style={{ fontSize: 10, display: "inline-flex", alignItems: "center", gap: 4 }}>
                <span style={{ width: 7, height: 7, borderRadius: "50%", background: c }}/>
                <span style={{ color: COLORS.fg2 }}>{k}</span>
              </span>
            ))}
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <Badge tone="warn">Anomaly</Badge>
            <div style={{ flex: 1, fontSize: 11, color: COLORS.fg1 }}>John K. & Acme LLC share 2 mailing addresses</div>
            <button className="cta cta--ghost" style={{ padding: "6px 10px", fontSize: 11 }}>Explain</button>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

Object.assign(window, {
  LayeredCardScreen, OrbitFavoritesScreen, MagneticGroupsScreen,
  AILoupeScreen, CommandPaletteScreen, VoiceGestureScreen,
  MapLayersScreen, TaxRadarScreen, TaxGraphScreen,
});
