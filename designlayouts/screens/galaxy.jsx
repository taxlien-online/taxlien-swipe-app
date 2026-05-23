// galaxy.jsx — Property Galaxy + Dimension Wheel + Lasso + Gravity + Timeline + Heatmap
// Each exported screen is a 402×774 (content area) device-frame interior.

// Common phone shell wrapper - content area between status bar and home indicator
function PhoneScreen({ children, dark = false }) {
  return <div className="phone-content" style={dark ? { background: "var(--bg-dark)" } : null}>{children}</div>;
}

// ────────────────────────────────────────────────────────────────
// 1. GALAXY — default ROI dimension
// ────────────────────────────────────────────────────────────────
function GalaxyScreen() {
  const points = layoutFor("roi");
  return (
    <PhoneScreen>
      <TopBar
        title="Galaxy"
        sub="847 properties · 12 counties"
        trailing={
          <React.Fragment>
            <IconButton label="filter">{Ico.filter}</IconButton>
            <IconButton label="ai" accent>{Ico.ai}</IconButton>
          </React.Fragment>
        }
      />
      <div className="galaxy">
        {/* dimension HUD */}
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.success }}/>
          {Ico.trend}
          <span>ROI</span>
          <span style={{ color: "var(--fg-2)", fontWeight: 400, marginLeft: 4 }}>/ value</span>
        </div>
        <div className="hud" style={{ top: 12, right: 12, fontSize: 11 }}>
          <span>847</span>
        </div>

        {/* Axis ghost labels */}
        <div style={{ position: "absolute", bottom: 8, left: 14, fontSize: 10, color: "var(--fg-2)", letterSpacing: 0.04 }}>0% ROI</div>
        <div style={{ position: "absolute", bottom: 8, right: 14, fontSize: 10, color: "var(--fg-2)" }}>30%+</div>
        <div style={{ position: "absolute", top: 56, left: 14, fontSize: 10, color: "var(--fg-2)", writingMode: "vertical-rl", transform: "rotate(180deg)" }}>Value</div>

        {/* property dots */}
        {points.map(p => (
          <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size} color={p.color}
                     halo={p.roi >= 0.22} opacity={p.stage === "sold" ? 0.35 : 1}/>
        ))}

        {/* Hot zone label */}
        <div style={{
          position: "absolute", top: 28, right: 24,
          padding: "4px 8px", borderRadius: 8,
          background: "rgba(31,182,122,0.10)",
          color: COLORS.success, fontSize: 10, fontWeight: 600,
          letterSpacing: 0.04, textTransform: "uppercase",
        }}>
          High-ROI cluster · 47
        </div>
      </div>

      {/* Bottom action strip */}
      <div style={{ padding: "12px 30px 16px", display: "flex", gap: 10 }}>
        <div className="floatpanel" style={{ flex: 1, display: "flex", gap: 12, alignItems: "center", padding: "10px 14px" }}>
          <div style={{ display: "flex", flexDirection: "column", gap: 2 }}>
            <span style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Showing</span>
            <span style={{ fontSize: 15, fontWeight: 600 }}>All 847</span>
          </div>
          <div style={{ width: 1, alignSelf: "stretch", background: COLORS.line }}/>
          <div style={{ display: "flex", flexDirection: "column", gap: 2 }}>
            <span style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Avg ROI</span>
            <span style={{ fontSize: 15, fontWeight: 600, color: COLORS.success }}>14.6%</span>
          </div>
          <div style={{ width: 1, alignSelf: "stretch", background: COLORS.line }}/>
          <div style={{ display: "flex", flexDirection: "column", gap: 2 }}>
            <span style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>New</span>
            <span style={{ fontSize: 15, fontWeight: 600, color: COLORS.brand }}>+24</span>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 2. GALAXY zoomed to a county cluster — mini cards
// ────────────────────────────────────────────────────────────────
function GalaxyZoomedScreen() {
  // Pick top-roi properties as the visible cards
  const cards = [...PROPERTIES].filter(p => p.county === "Maricopa" && p.stage !== "sold")
                .sort((a,b) => b.roi - a.roi).slice(0, 6);
  // ROI palette per card
  return (
    <PhoneScreen>
      <TopBar
        title="Maricopa, AZ"
        sub="142 properties · 24 visible"
        leading={
          <button className="icon-btn" aria-label="back">{Ico.back}</button>
        }
        trailing={
          <React.Fragment>
            <IconButton label="filter">{Ico.filter}</IconButton>
            <IconButton label="ai" accent>{Ico.ai}</IconButton>
          </React.Fragment>
        }
      />
      <div className="galaxy" style={{ padding: 12 }}>
        <div className="hud" style={{ top: 12, left: 12, zIndex: 2 }}>
          <span className="hud__dot" style={{ background: COLORS.success }}/>
          {Ico.trend}<span>ROI</span>
        </div>
        <div style={{
          position: "absolute", top: 12, right: 12,
          display: "flex", gap: 6, alignItems: "center",
          fontSize: 11, color: COLORS.fg2, padding: "5px 9px",
          background: "rgba(255,255,255,0.86)", borderRadius: 999,
          boxShadow: "var(--shadow-card)", fontWeight: 500,
        }}>
          <span>2.4×</span>
          <span style={{ color: COLORS.fg1 }}>·</span>
          <span>{Ico.refresh}</span>
        </div>

        <div style={{
          position: "absolute", inset: "52px 8px 8px", display: "grid",
          gridTemplateColumns: "1fr 1fr", gap: 8, overflow: "hidden",
        }}>
          {cards.map(p => (
            <MiniPropertyCard key={p.id} p={p}/>
          ))}
        </div>
      </div>
      <div style={{ padding: "12px 30px 16px" }}>
        <div className="floatpanel" style={{ display: "flex", alignItems: "center", gap: 10, padding: "12px 14px" }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 12, color: COLORS.fg2 }}>Pinch out to zoom back · double-tap dot to expand</div>
          </div>
          <button className="cta" style={{ padding: "10px 14px", fontSize: 13 }}>
            View list
          </button>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

function MiniPropertyCard({ p }) {
  const stageTone = p.stage === "pre-auction" ? "warn"
                  : p.stage === "otc" ? "cyan"
                  : p.stage === "sold" ? "neutral"
                  : "info";
  const stageLabel = { "pre-auction":"PRE", listed:"LIEN", otc:"OTC", sold:"SOLD" }[p.stage];
  return (
    <div className="surface-card" style={{
      padding: 10, display: "flex", flexDirection: "column", gap: 6,
      border: p.roi >= 0.18 ? `1px solid ${COLORS.success}33` : "none",
      position: "relative", overflow: "hidden",
    }}>
      {p.roi >= 0.22 && (
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, height: 3,
          background: "var(--brand-gradient)",
        }}/>
      )}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 500 }}>{p.address.split(" ")[0]} {p.address.split(" ").slice(1).join(" ")}</span>
        <Badge tone={stageTone}>{stageLabel}</Badge>
      </div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
        <span style={{ fontSize: 18, fontWeight: 600, letterSpacing: -0.01 }}>{usd(p.tax)}</span>
        <span style={{ fontSize: 14, fontWeight: 600, color: p.roi >= 0.15 ? COLORS.success : COLORS.fg1 }}>{pct(p.roi)}</span>
      </div>
      <div style={{ display: "flex", justifyContent: "space-between", fontSize: 10, color: COLORS.fg2 }}>
        <span>Value {usd(p.value)}</span>
        <span style={{ display: "inline-flex", gap: 3, alignItems: "center", color: colorByRisk(p.risk) }}>
          <span style={{ width: 5, height: 5, borderRadius: "50%", background: "currentColor" }}/>
          {p.risk}
        </span>
      </div>
    </div>
  );
}

// ────────────────────────────────────────────────────────────────
// 3. DIMENSION WHEEL overlay
// ────────────────────────────────────────────────────────────────
function DimensionWheelScreen() {
  const dims = [
    { id: "roi",     label: "ROI",         icon: Ico.trend,   color: COLORS.success,  desc: "Return on investment × value" },
    { id: "risk",    label: "Risk",        icon: Ico.warn,    color: COLORS.danger,   desc: "Risk score × redemption" },
    { id: "stage",   label: "Stage",       icon: Ico.layers,  color: COLORS.brand,    desc: "Pre · Listed · OTC · Sold" },
    { id: "county",  label: "County",      icon: Ico.map,     color: COLORS.brand,    desc: "Clustered by jurisdiction" },
    { id: "date",    label: "Date",        icon: Ico.cal,     color: COLORS.warning,  desc: "Auction timeline" },
    { id: "fvi",     label: "FVI",         icon: Ico.star,    color: COLORS.success,  desc: "Family Value Index" },
    { id: "type",    label: "Type",        icon: Ico.home,    color: COLORS.brand,    desc: "Residential · Land · Commercial" },
    { id: "priorY",  label: "Prior Years", icon: Ico.refresh, color: COLORS.danger,   desc: "Delinquency depth · tax", post: true },
    { id: "exempt",  label: "Exemptions",  icon: Ico.shield,  color: COLORS.purple,   desc: "Homestead · Veteran · Senior", post: true },
    { id: "tenure",  label: "Tenure",      icon: Ico.user,    color: COLORS.brand,    desc: "Owner since × redemption", post: true },
    { id: "payback", label: "Payback",     icon: Ico.clock,   color: COLORS.warning,  desc: "Months to return × ROI", post: true },
    { id: "taxYr",   label: "Tax Year",    icon: Ico.cal,     color: COLORS.fg2,      desc: "Year × county", post: true },
  ];

  // Background galaxy dimmed
  const points = layoutFor("roi");

  return (
    <PhoneScreen>
      <TopBar title="Galaxy" sub="Choose a dimension" trailing={
        <IconButton label="close">{Ico.close}</IconButton>
      }/>
      <div className="galaxy" style={{ position: "relative" }}>
        {/* dimmed background dots */}
        <div style={{ position: "absolute", inset: 0, filter: "blur(1px)", opacity: 0.35 }}>
          {points.map(p => (
            <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*0.7} color={p.color}/>
          ))}
        </div>
        {/* dark scrim */}
        <div style={{ position: "absolute", inset: 0, background: "rgba(248,249,250,0.55)", backdropFilter: "blur(2px)" }}/>

        {/* wheel-grid */}
        <div style={{
          position: "absolute", inset: "16px 14px 14px",
          display: "grid", gridTemplateColumns: "1fr 1fr 1fr",
          gap: 8, alignContent: "start",
        }}>
          {dims.map((d, i) => (
            <button key={d.id} style={{
              background: i === 0 ? "var(--surface)" : "rgba(255,255,255,0.9)",
              border: i === 0 ? `2px solid ${d.color}` : "1px solid var(--line)",
              borderRadius: 12,
              padding: 10, display: "flex", flexDirection: "column", gap: 6,
              boxShadow: i === 0 ? `0 6px 18px ${d.color}22` : "0 1px 4px rgba(48,63,73,0.06)",
              textAlign: "left", color: "var(--fg-1)", cursor: "pointer",
              position: "relative", aspectRatio: "1.05",
            }}>
              {d.post && (
                <span style={{
                  position: "absolute", top: 6, right: 6,
                  fontSize: 8, fontWeight: 700, color: COLORS.fg2,
                  letterSpacing: 0.06,
                }}>+</span>
              )}
              <span style={{ color: d.color, display: "inline-flex" }}>{d.icon}</span>
              <span style={{ fontSize: 13, fontWeight: 600, lineHeight: 1.1 }}>{d.label}</span>
              <span style={{ fontSize: 9.5, color: COLORS.fg2, lineHeight: 1.25 }}>{d.desc}</span>
            </button>
          ))}
        </div>
      </div>
      <div style={{ padding: "10px 30px 14px" }}>
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
          color: COLORS.fg2, fontSize: 12,
        }}>
          <svg width="40" height="14" viewBox="0 0 40 14" fill="none">
            <circle cx="6" cy="7" r="3" stroke="currentColor" strokeWidth="1.2"/>
            <circle cx="34" cy="7" r="3" stroke="currentColor" strokeWidth="1.2"/>
            <path d="M9 7 Q20 0 31 7" stroke="currentColor" strokeWidth="1" strokeDasharray="2 2"/>
          </svg>
          Two-finger rotate on canvas to cycle dimensions
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 4. LASSO selection — drawing in progress
// ────────────────────────────────────────────────────────────────
function LassoDrawingScreen() {
  const points = layoutFor("county");
  // Lasso path (rough loop covering top-right Maricopa cluster)
  const lassoPath = "M 60 60 C 80 40, 130 35, 175 50 S 245 55, 275 80 S 290 130, 270 165 S 200 195, 145 185 S 80 165, 60 130 S 50 80, 60 60 Z";

  // Determine which points are inside (approx ellipse around centroid)
  const selectedIds = new Set();
  points.forEach(p => {
    const px = p.x / 100 * 330 + 15;
    const py = p.y / 100 * 380 + 30;
    if (px > 50 && px < 290 && py > 35 && py < 200 &&
        Math.hypot((px-170)/120, (py-115)/85) < 1.1) selectedIds.add(p.id);
  });

  return (
    <PhoneScreen>
      <TopBar
        title="Galaxy"
        sub="Drag to select"
        trailing={
          <button className="icon-btn" style={{ background: "var(--brand-gradient)", color: "#fff" }}>
            <span style={{ fontSize: 10, fontWeight: 700, letterSpacing: 0.08 }}>LASSO</span>
          </button>
        }
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.brand }}/>
          {Ico.map}<span>County</span>
        </div>

        {/* dots */}
        {points.map(p => {
          const sel = selectedIds.has(p.id);
          return (
            <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size}
                       color={sel ? COLORS.brand : p.color}
                       halo={sel} opacity={sel ? 1 : 0.55}/>
          );
        })}

        {/* lasso SVG */}
        <svg style={{ position: "absolute", inset: 0, pointerEvents: "none" }}
             viewBox="0 0 330 410" preserveAspectRatio="none">
          <defs>
            <linearGradient id="lassoG" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0" stopColor="#00C6FB"/>
              <stop offset="1" stopColor="#005BEA"/>
            </linearGradient>
          </defs>
          <path d={lassoPath}
                fill="url(#lassoG)" fillOpacity="0.10"
                stroke="url(#lassoG)" strokeWidth="2"
                strokeDasharray="6 4"
                strokeLinecap="round"/>
          {/* drawing finger */}
          <circle cx="60" cy="60" r="14" fill="white" stroke="#005BEA" strokeWidth="2"/>
          <circle cx="60" cy="60" r="5"  fill="#005BEA"/>
        </svg>
      </div>
      <div style={{ padding: "12px 30px 16px" }}>
        <div className="floatpanel" style={{
          display: "flex", alignItems: "center", gap: 12, padding: "12px 14px",
        }}>
          <div style={{ display: "inline-flex", padding: 8, borderRadius: 8, background: "rgba(0,91,234,0.10)", color: COLORS.brand }}>
            {Ico.link}
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>Drawing selection…</div>
            <div style={{ fontSize: 12, color: COLORS.fg2 }}>{selectedIds.size} enclosed · close loop to finish</div>
          </div>
          <button className="cta cta--ghost" style={{ padding: "8px 12px", fontSize: 13 }}>Cancel</button>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 5. LASSO complete — selection panel
// ────────────────────────────────────────────────────────────────
function LassoSelectedScreen() {
  const points = layoutFor("county");
  // Use 14 selected
  const selected = points.slice(8, 22);
  const selIds = new Set(selected.map(p => p.id));
  const stats = selectionStats(selected);

  return (
    <PhoneScreen>
      <TopBar
        title="14 selected"
        sub="Lasso · Maricopa cluster"
        leading={<button className="icon-btn" aria-label="close">{Ico.close}</button>}
        trailing={<IconButton label="more">{Ico.more}</IconButton>}
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.brand }}/>
          {Ico.map}<span>County</span>
        </div>

        {points.map(p => {
          const sel = selIds.has(p.id);
          return (
            <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size}
                       color={sel ? COLORS.brand : p.color}
                       opacity={sel ? 1 : 0.18}
                       halo={sel}/>
          );
        })}

        {/* enclosing shape with fill */}
        <svg style={{ position: "absolute", inset: 0, pointerEvents: "none" }}
             viewBox="0 0 330 410" preserveAspectRatio="none">
          <path d="M 55 55 C 80 35, 145 30, 200 50 S 285 70, 280 130 S 245 200, 165 195 S 60 170, 50 110 S 40 75, 55 55 Z"
                fill="rgba(0,91,234,0.06)"
                stroke="#005BEA" strokeWidth="2" strokeLinecap="round"/>
        </svg>
      </div>

      {/* Floating selection panel */}
      <div style={{ padding: "10px 16px 16px" }}>
        <div className="floatpanel" style={{ padding: 14 }}>
          <div style={{ display: "flex", alignItems: "baseline", gap: 8, marginBottom: 10 }}>
            <span style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.01 }}>{stats.count}</span>
            <span style={{ fontSize: 13, color: COLORS.fg2 }}>properties selected</span>
            <span style={{ flex: 1 }}/>
            <span style={{ fontSize: 13, color: COLORS.brand, fontWeight: 500 }}>Maricopa, AZ</span>
          </div>
          <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
            <StatTile label="Total" value={usd(stats.totalValue)}/>
            <StatTile label="Avg ROI" value={pct(stats.avgRoi)} accent={COLORS.success}/>
            <StatTile label="Risk" value={`${stats.lowR}·${stats.midR}·${stats.hiR}`} sub="L · M · H"/>
          </div>
          <div style={{ display: "flex", gap: 8 }}>
            <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "11px 12px" }}>
              {Ico.heart} Watchlist
            </button>
            <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "11px 12px" }}>
              {Ico.list} Compare
            </button>
            <button className="cta" style={{ flex: 1, fontSize: 13, padding: "11px 12px" }}>
              Export
            </button>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 6. RISK GRAVITY view
// ────────────────────────────────────────────────────────────────
function GravityScreen() {
  // 3 anchor hot properties with orbiting related
  const anchors = [
    { x: 32, y: 30, size: 36, label: "Same owner · 5", angle: 0 },
    { x: 70, y: 55, size: 30, label: "Same street · 8", angle: 0.3 },
    { x: 40, y: 75, size: 26, label: "Same county · 12", angle: 0.7 },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Risk gravity" sub="Hot properties attract related"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="off">{Ico.close}</IconButton>}
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.danger }}/>
          {Ico.warn}<span>Gravity on</span>
        </div>

        {/* Sparse cold properties */}
        {PROPERTIES.slice(0, 22).map((p, i) => (
          <GalaxyDot key={p.id} x={5 + ((i*37)%90)} y={10 + ((i*61)%82)} size={6} color={COLORS.fg2} opacity={0.35}/>
        ))}

        {anchors.map((a, ai) => (
          <React.Fragment key={ai}>
            {/* gravity well rings */}
            {[1,2,3].map(r => (
              <div key={r} style={{
                position: "absolute", left: `${a.x}%`, top: `${a.y}%`,
                width: a.size*r*1.4, height: a.size*r*1.4, borderRadius: "50%",
                transform: "translate(-50%,-50%)",
                border: `1px solid ${COLORS.danger}${["55","30","18"][r-1]}`,
                background: r === 1 ? `radial-gradient(circle, ${COLORS.danger}28 0%, transparent 70%)` : "none",
                pointerEvents: "none",
              }}/>
            ))}
            {/* orbiting satellites */}
            {[0,1,2,3,4].map(k => {
              const phi = a.angle + k * (Math.PI*2/5);
              const r = a.size * 1.4;
              const px = a.x + Math.cos(phi)*r/3.3;
              const py = a.y + Math.sin(phi)*r/2.4;
              return (
                <React.Fragment key={k}>
                  <svg style={{ position:"absolute", inset:0, pointerEvents:"none" }} viewBox="0 0 100 100" preserveAspectRatio="none">
                    <line x1={a.x} y1={a.y} x2={px} y2={py} stroke={COLORS.danger} strokeWidth="0.2" strokeDasharray="0.8 0.8" opacity="0.4"/>
                  </svg>
                  <GalaxyDot x={px} y={py} size={7} color={COLORS.danger} opacity={0.7}/>
                </React.Fragment>
              );
            })}
            {/* center hot */}
            <GalaxyDot x={a.x} y={a.y} size={a.size*0.45} color={COLORS.danger} halo/>
            <div style={{
              position: "absolute", left: `${a.x}%`, top: `${a.y + 9}%`,
              transform: "translateX(-50%)", fontSize: 9.5,
              padding: "2px 6px", borderRadius: 4,
              background: "rgba(255,255,255,0.9)", color: COLORS.fg1, fontWeight: 600,
              whiteSpace: "nowrap", boxShadow: "var(--shadow-card)",
            }}>{a.label}</div>
          </React.Fragment>
        ))}
      </div>
      <div style={{ padding: "12px 30px 16px" }}>
        <div className="floatpanel" style={{ padding: 12, display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ flex: 1, fontSize: 12, color: COLORS.fg1 }}>
            <div style={{ fontWeight: 600 }}>3 contamination clusters detected</div>
            <div style={{ color: COLORS.fg2, marginTop: 2 }}>Tap any orbit to inspect relation</div>
          </div>
          <button className="cta cta--ghost" style={{ padding: "8px 12px", fontSize: 13 }}>Filter</button>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 7. TIMELINE REPLAY — chronological scrubber
// ────────────────────────────────────────────────────────────────
function TimelineReplayScreen() {
  // Properties as they appeared month-by-month
  // Show timeline strip and currently-visible dots
  const months = ["Jan","Feb","Mar","Apr","May","Jun"];
  const cursor = 0.55; // current playback position
  const visible = PROPERTIES.slice(0, Math.floor(PROPERTIES.length * cursor));
  const points = layoutFor("date");
  const visibleIds = new Set(visible.map(p => p.id));

  return (
    <PhoneScreen>
      <TopBar title="Timeline replay" sub="May 2026 · 44 active"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div className="galaxy">
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.brand }}/>
          {Ico.cal}<span>Date</span>
        </div>
        <div className="hud" style={{ top: 12, right: 12 }}>
          <span style={{ fontWeight: 600, color: COLORS.danger }}>●</span>
          <span style={{ fontSize: 11 }}>REC</span>
        </div>

        {points.map(p => {
          const inView = visibleIds.has(p.id);
          return (
            <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size}
                       color={p.color} opacity={inView ? 1 : 0.08}
                       halo={inView && p.auctionDays < 14}/>
          );
        })}

        {/* "appearing" sparkle on newest */}
        {visible.slice(-5).map((p, i) => {
          const pp = points.find(x => x.id === p.id);
          if (!pp) return null;
          return (
            <div key={p.id} style={{
              position: "absolute", left: `${pp.x}%`, top: `${pp.y}%`,
              transform: "translate(-50%,-50%)",
              width: pp.size*2.4, height: pp.size*2.4, borderRadius: "50%",
              border: `1px solid ${COLORS.cyan}`,
              opacity: 0.7 - i*0.12, pointerEvents: "none",
            }}/>
          );
        })}
      </div>

      <div style={{ padding: "12px 16px 16px" }}>
        <div className="floatpanel" style={{ padding: 14 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 12 }}>
            <button style={{
              width: 44, height: 44, borderRadius: "50%", border: 0,
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              boxShadow: "0 6px 18px rgba(0,91,234,0.25)",
            }}>{Ico.pause}</button>
            <div style={{ flex: 1 }}>
              <div style={{ display: "flex", justifyContent: "space-between", fontSize: 11, color: COLORS.fg2, marginBottom: 4 }}>
                <span>Jan 1, 2026</span>
                <span style={{ color: COLORS.brand, fontWeight: 600 }}>May 18, 2026</span>
                <span>Jun 30</span>
              </div>
              <div style={{ position: "relative", height: 28 }}>
                <div style={{ position: "absolute", top: 12, left: 0, right: 0, height: 4, borderRadius: 4, background: "var(--disabled)" }}/>
                <div style={{ position: "absolute", top: 12, left: 0, width: `${cursor*100}%`, height: 4, borderRadius: 4, background: "var(--brand-gradient)" }}/>
                {/* tick marks per month */}
                {months.map((m, i) => (
                  <div key={m} style={{
                    position: "absolute", left: `${(i/(months.length-1))*100}%`,
                    top: 4, transform: "translateX(-50%)", textAlign: "center",
                  }}>
                    <div style={{ width: 1, height: 6, background: COLORS.fg2, opacity: 0.4, margin: "0 auto" }}/>
                    <div style={{ fontSize: 9, color: COLORS.fg2, marginTop: 2 }}>{m}</div>
                  </div>
                ))}
                {/* thumb */}
                <div style={{
                  position: "absolute", top: 6, left: `${cursor*100}%`,
                  transform: "translateX(-50%)",
                  width: 16, height: 16, borderRadius: "50%",
                  background: "#fff", border: "2px solid var(--brand-blue)",
                  boxShadow: "0 2px 6px rgba(0,91,234,0.25)",
                }}/>
              </div>
            </div>
          </div>
          <div style={{ display: "flex", gap: 6 }}>
            {["1×","2×","5×"].map((s, i) => (
              <button key={s} style={{
                flex: 1, padding: "6px 8px", fontSize: 12,
                background: i === 1 ? "var(--brand-blue)" : "var(--surface)",
                color: i === 1 ? "#fff" : "var(--fg-1)",
                border: i === 1 ? "0" : "1px solid var(--line)",
                borderRadius: 8, fontWeight: 500,
              }}>{s}</button>
            ))}
            <button style={{
              padding: "6px 10px", fontSize: 12, background: "var(--surface)",
              border: "1px solid var(--line)", borderRadius: 8,
              color: "var(--fg-1)", display: "inline-flex", alignItems: "center", gap: 4,
            }}>{Ico.reset} Reset</button>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 8. TIMELINE HEATMAP — county × month matrix
// ────────────────────────────────────────────────────────────────
function HeatmapScreen() {
  const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug"];
  const countiesRows = COUNTIES.slice(0, 8);
  // Deterministic intensity
  const grid = countiesRows.map((c, ci) =>
    months.map((m, mi) => {
      const v = ((ci*7 + mi*11 + (ci*mi)) % 100) / 100;
      return v;
    })
  );

  return (
    <PhoneScreen>
      <TopBar title="Heatmap" sub="Counties × months · tax value"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="filter">{Ico.filter}</IconButton>}
      />
      <div style={{ padding: "0 20px" }}>
        <div className="surface-card" style={{ padding: 14 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 10 }}>
            <div>
              <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", fontWeight: 600, letterSpacing: 0.06 }}>2026 H1</div>
              <div style={{ fontSize: 16, fontWeight: 600 }}>$48.2M total tax due</div>
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: COLORS.fg2 }}>
              <div style={{ width: 60, height: 8, borderRadius: 4,
                background: "linear-gradient(90deg, rgba(0,91,234,0.06), rgba(0,91,234,0.55), rgba(229,72,77,0.85))" }}/>
              <span>$50k → $4M</span>
            </div>
          </div>
          {/* matrix */}
          <div style={{
            display: "grid",
            gridTemplateColumns: `74px repeat(${months.length}, 1fr)`,
            gap: 3, alignItems: "center",
          }}>
            <div/>
            {months.map(m => (
              <div key={m} style={{ fontSize: 10, color: COLORS.fg2, textAlign: "center", fontWeight: 500 }}>{m}</div>
            ))}
            {countiesRows.map((c, ci) => (
              <React.Fragment key={c.name}>
                <div style={{ fontSize: 11, color: COLORS.fg1, fontWeight: 500 }}>
                  {c.name}
                  <span style={{ color: COLORS.fg2, marginLeft: 4, fontSize: 10 }}>{c.state}</span>
                </div>
                {grid[ci].map((v, mi) => {
                  const r = Math.round(0 + v * 229);
                  const g = Math.round(91 - v * 80);
                  const b = Math.round(234 - v * 200);
                  const bg = `rgba(${r}, ${Math.max(g, 50)}, ${b}, ${0.15 + v * 0.7})`;
                  const isHot = v > 0.72;
                  return (
                    <div key={mi} style={{
                      aspectRatio: "1", borderRadius: 4, background: bg,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      fontSize: 9, color: v > 0.4 ? "#fff" : COLORS.fg1,
                      fontWeight: 600, position: "relative",
                      border: isHot ? "1px solid #fff" : "0",
                      outline: isHot ? "1.5px solid rgba(229,72,77,0.45)" : "none",
                    }}>
                      {v > 0.5 ? Math.round(v*40) : ""}
                    </div>
                  );
                })}
              </React.Fragment>
            ))}
          </div>
          <hr className="divider"/>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
            <Badge tone="hot" icon={<span style={{ width: 5, height: 5, borderRadius: "50%", background: "currentColor" }}/>}>Hot: Duval Mar</Badge>
            <Badge tone="info">Pinch to zoom: year → quarter → week</Badge>
          </div>
        </div>

        <div style={{ marginTop: 12, display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
          <div className="surface-card" style={{ padding: 12 }}>
            <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.05, fontWeight: 600 }}>Peak month</div>
            <div style={{ fontSize: 18, fontWeight: 700, marginTop: 4 }}>March</div>
            <div style={{ fontSize: 11, color: COLORS.success, marginTop: 2 }}>+34% vs avg</div>
          </div>
          <div className="surface-card" style={{ padding: 12 }}>
            <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.05, fontWeight: 600 }}>Top county</div>
            <div style={{ fontSize: 18, fontWeight: 700, marginTop: 4 }}>Duval, FL</div>
            <div style={{ fontSize: 11, color: COLORS.fg2, marginTop: 2 }}>$8.4M · 203 liens</div>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

Object.assign(window, {
  PhoneScreen, MiniPropertyCard,
  GalaxyScreen, GalaxyZoomedScreen, DimensionWheelScreen,
  LassoDrawingScreen, LassoSelectedScreen,
  GravityScreen, TimelineReplayScreen, HeatmapScreen,
});
