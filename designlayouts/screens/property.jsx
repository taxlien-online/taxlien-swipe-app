// property.jsx — Property detail card, X-Ray mode, Swipe Focus, Comparison Bridge,
// Badges, Property-as-living-object states.

// Image placeholder w/ a low-contrast house illustration
function PropertyImage({ height = 160, tone = "warm", badge, scratched }) {
  const gradients = {
    warm: "linear-gradient(135deg, #E8DCC5 0%, #B89F7E 40%, #8E785A 100%)",
    cool: "linear-gradient(135deg, #D8E2EC 0%, #9DB3C6 50%, #6F88A1 100%)",
    desert: "linear-gradient(135deg, #F3E0C2 0%, #D9B58A 50%, #A88456 100%)",
    forest: "linear-gradient(135deg, #C9D9B8 0%, #8DAA72 50%, #5C7748 100%)",
  };
  return (
    <div style={{
      height, width: "100%", borderRadius: 12, overflow: "hidden",
      background: gradients[tone] || gradients.warm,
      position: "relative",
    }}>
      {/* Sun glow */}
      <div style={{ position: "absolute", top: 14, right: 22, width: 36, height: 36,
                    borderRadius: "50%", background: "rgba(255,247,220,0.85)",
                    boxShadow: "0 0 24px 8px rgba(255,247,220,0.5)" }}/>
      {/* Roof / house silhouette */}
      <svg viewBox="0 0 400 160" preserveAspectRatio="none" style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
        <path d="M0 130 L60 130 L60 95 L130 60 L200 95 L200 80 L260 80 L260 110 L320 110 L320 95 L400 95 L400 160 L0 160 Z"
              fill="rgba(48,63,73,0.55)"/>
        <path d="M0 145 L400 145 L400 160 L0 160 Z" fill="rgba(48,63,73,0.85)"/>
        {/* windows */}
        <rect x="78" y="108" width="8" height="10" fill="rgba(255,247,220,0.75)"/>
        <rect x="98" y="108" width="8" height="10" fill="rgba(255,247,220,0.75)"/>
        <rect x="118" y="108" width="8" height="10" fill="rgba(255,247,220,0.75)"/>
        <rect x="220" y="92" width="6" height="8" fill="rgba(255,247,220,0.85)"/>
        <rect x="234" y="92" width="6" height="8" fill="rgba(255,247,220,0.85)"/>
        <rect x="338" y="108" width="6" height="6" fill="rgba(255,247,220,0.6)"/>
        {scratched && (
          <g stroke="rgba(229,72,77,0.65)" strokeWidth="1.5" fill="none">
            <path d="M130 50 L160 90 M150 55 L185 80"/>
          </g>
        )}
      </svg>
      {badge}
    </div>
  );
}

// All property badges referenced in requirements
function PropBadge({ kind }) {
  const map = {
    HOMESTEAD:  { tone: "purple", label: "Homestead",  icon: "♡" },
    MULTI:      { tone: "hot",    label: "Multi-year", icon: "!" },
    FLOOD:      { tone: "info",   label: "Flood",      icon: "≈" },
    NOHEIRS:    { tone: "warn",   label: "No heirs",   icon: "△" },
    VETERAN:    { tone: "good",   label: "Veteran",    icon: "★" },
    SENIOR:     { tone: "cyan",   label: "Senior",     icon: "❘" },
    QUICKPAY:   { tone: "warn",   label: "Quick pay",  icon: "⧖" },
    HIGHROI:    { tone: "good",   label: "High ROI",   icon: "↗" },
    STALE:      { tone: "neutral",label: "Stale",      icon: "↻" },
    NEW:        { tone: "info",   label: "New",        icon: "✦" },
    OTC:        { tone: "cyan",   label: "OTC",        icon: "·" },
    NFT:        { tone: "purple", label: "Tokenized",  icon: "⬢" },
  };
  const b = map[kind] || { tone: "neutral", label: kind, icon: "·" };
  return <Badge tone={b.tone}><span style={{ fontWeight: 800 }}>{b.icon}</span>{b.label}</Badge>;
}

// ────────────────────────────────────────────────────────────────
// 1. PROPERTY DETAIL — normal (calm utility view)
// ────────────────────────────────────────────────────────────────
function PropertyDetailScreen() {
  const p = {
    address: "1247 Oak Street", city: "Phoenix", state: "AZ", zip: "85008",
    county: "Maricopa", parcel: "123-45-678",
    value: 89000, tax: 12450, roi: 0.185, risk: 32, redemp: 0.74,
    fvi: 8.2, payback: 8, intRate: 0.16, beds: 3, baths: 2, sqft: 1640, yr: 1978,
    walk: 64, school: 7.8, flood: "Zone X",
    auctionDate: "Jun 15, 2026", stage: "listed",
  };

  return (
    <PhoneScreen>
      <TopBar
        title="Property"
        sub={p.parcel}
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <React.Fragment>
            <IconButton label="watch">{Ico.starO}</IconButton>
            <IconButton label="xray" accent>{Ico.xray}</IconButton>
          </React.Fragment>
        }
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        <PropertyImage height={170} tone="desert" badge={
          <div style={{
            position: "absolute", left: 12, bottom: 12, display: "flex", gap: 6,
          }}>
            <Badge tone="info">LIEN · LISTED</Badge>
            <Badge tone="good"><span style={{ fontWeight: 800 }}>↗</span>HIGH ROI</Badge>
          </div>
        }/>
        <div style={{ marginTop: 14 }}>
          <div style={{ fontSize: 20, fontWeight: 600, letterSpacing: -0.01 }}>{p.address}</div>
          <div style={{ fontSize: 14, color: COLORS.fg2, marginTop: 2 }}>{p.city}, {p.state} {p.zip} · {p.county} County</div>
        </div>

        <div style={{ display: "flex", gap: 8, marginTop: 14 }}>
          <StatTile label="Lien" value={usdFull(p.tax)} sub={`@ ${(p.intRate*100).toFixed(0)}%`} accent={COLORS.brand}/>
          <StatTile label="Est. value" value={usdFull(p.value)} sub="Zillow $94k" accent={COLORS.fg1}/>
          <StatTile label="ROI" value={pct(p.roi)} sub={`${p.payback}mo payback`} accent={COLORS.success}/>
        </div>

        <div style={{ display: "flex", gap: 8, marginTop: 8 }}>
          <StatTile label="Risk" value={`${p.risk}/100`} sub="Low" accent={COLORS.success}/>
          <StatTile label="Redempt." value={`${Math.round(p.redemp*100)}%`} sub="likely" accent={COLORS.brand}/>
          <StatTile label="FVI" value={p.fvi.toFixed(1)} sub="of 10" accent={COLORS.success}/>
        </div>

        {/* Auction strip */}
        <div className="surface-card" style={{ padding: 14, marginTop: 12 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <div>
              <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Auction</div>
              <div style={{ fontSize: 17, fontWeight: 600, marginTop: 2 }}>{p.auctionDate}</div>
              <div style={{ fontSize: 12, color: COLORS.brand }}>in 27 days · 14:00 MST</div>
            </div>
            <button className="cta" style={{ padding: "12px 18px", fontSize: 14 }}>Make offer</button>
          </div>
        </div>

        {/* Specs */}
        <div className="surface-card" style={{ padding: 14, marginTop: 10 }}>
          <Row k="Property type"  v="Residential SFR"/>
          <Row k="Bed · Bath"     v={`${p.beds} · ${p.baths}`}/>
          <Row k="Building / Year" v={`${p.sqft.toLocaleString()} sqft · ${p.yr}`}/>
          <Row k="Walkability"    v={`${p.walk} / 100`}/>
          <Row k="Schools"        v={`${p.school} / 10`}/>
          <Row k="Flood zone"     v={p.flood} last/>
        </div>

        <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
          <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "12px 12px" }}>
            {Ico.heart} Watchlist
          </button>
          <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "12px 12px" }}>
            {Ico.scale} Compare
          </button>
          <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "12px 12px" }}>
            {Ico.link} Share
          </button>
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function Row({ k, v, last }) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", padding: "10px 0",
      borderBottom: last ? "none" : "1px solid var(--line)",
      fontSize: 14,
    }}>
      <span style={{ color: COLORS.fg2 }}>{k}</span>
      <span style={{ color: COLORS.fg1, fontWeight: 500 }}>{v}</span>
    </div>
  );
}

// ────────────────────────────────────────────────────────────────
// 2. X-RAY MODE — insights overlay
// ────────────────────────────────────────────────────────────────
function XRayScreen() {
  const insights = [
    { kind: "warn", icon: Ico.warn,  title: "Flood zone AE",
      detail: "FEMA hazard area · insurance required ~$1.4k/yr" },
    { kind: "warn", icon: Ico.refresh, title: "3 years delinquent",
      detail: "Severely distressed · prior owners failed to redeem in '23, '24" },
    { kind: "opp",  icon: Ico.trend, title: "High ROI · 18.5%",
      detail: "Top 12% in Maricopa over last 90 days" },
    { kind: "opp",  icon: Ico.clock, title: "Quick payback · 8 mo",
      detail: "Below county median of 14 months" },
    { kind: "opp",  icon: Ico.bolt,  title: "Zillow 12% above assessment",
      detail: "Est. $94k vs assessed $89k · possible undervaluation" },
    { kind: "eth",  icon: Ico.shield, title: "Senior homeowner",
      detail: "Owner age ≥ 65 · ethical consideration before bid" },
    { kind: "info", icon: Ico.user,  title: "Owner since 2018",
      detail: "6 years tenure · 74% redemption probability" },
  ];

  const toneFor = (k) => k === "warn" ? COLORS.danger
                      : k === "opp"  ? COLORS.success
                      : k === "eth"  ? COLORS.purple
                                     : COLORS.brand;

  return (
    <PhoneScreen>
      <TopBar
        title="X-Ray"
        sub="1247 Oak Street · Maricopa"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <div style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            padding: "6px 10px", borderRadius: 999,
            background: "var(--brand-gradient)", color: "#fff",
            fontSize: 11, fontWeight: 700, letterSpacing: 0.06,
          }}>
            {Ico.xray} ACTIVE
          </div>
        }
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* X-ray image overlay */}
        <div style={{ position: "relative" }}>
          <PropertyImage height={160} tone="desert" scratched badge={
            <div style={{
              position: "absolute", inset: 0, borderRadius: 12,
              background: "linear-gradient(180deg, rgba(229,72,77,0.04), rgba(0,91,234,0.04))",
              border: "1px dashed rgba(229,72,77,0.45)",
              display: "flex", flexDirection: "column", justifyContent: "space-between",
              padding: 10,
            }}>
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <Badge tone="hot" icon={<span style={{ fontWeight: 800 }}>!</span>}>Roof age 18yr</Badge>
                <Badge tone="info">Photo · 2024</Badge>
              </div>
              <div style={{
                alignSelf: "flex-end",
                fontSize: 9, fontWeight: 700, color: "rgba(255,255,255,0.9)",
                letterSpacing: 0.08, padding: "3px 7px",
                background: "rgba(229,72,77,0.85)", borderRadius: 4,
                textTransform: "uppercase",
              }}>Stale · 462 days</div>
            </div>
          }/>
        </div>

        {/* AI summary */}
        <div style={{
          marginTop: 12, padding: 14, borderRadius: 12,
          background: "linear-gradient(180deg, #E6F8FF 0%, #E6EEFD 100%)",
          border: "1px solid rgba(0,91,234,0.18)",
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 6 }}>
            <div style={{
              width: 24, height: 24, borderRadius: "50%",
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.ai}</div>
            <span style={{ fontSize: 11, fontWeight: 700, color: COLORS.brand, textTransform: "uppercase", letterSpacing: 0.06 }}>AI Summary</span>
          </div>
          <p style={{ fontSize: 14, color: COLORS.fg1, lineHeight: 1.4, margin: 0 }}>
            High ROI opportunity but multi-year distressed. Senior owner with strong redemption probability — you likely earn 16% interest, not the deed. Verify flood insurance cost; roof age may affect post-deed value.
          </p>
        </div>

        {/* Insight rows */}
        <div style={{ marginTop: 12 }}>
          {insights.map((ins, i) => (
            <div key={i} style={{
              display: "flex", gap: 12, padding: "10px 0",
              borderBottom: i < insights.length-1 ? "1px solid var(--line)" : "none",
            }}>
              <div style={{
                width: 32, height: 32, borderRadius: 8, flexShrink: 0,
                background: toneFor(ins.kind) + "1c",
                color: toneFor(ins.kind),
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>{ins.icon}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                  <span style={{ fontSize: 14, fontWeight: 600, color: COLORS.fg1 }}>{ins.title}</span>
                </div>
                <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2, lineHeight: 1.35 }}>{ins.detail}</div>
              </div>
            </div>
          ))}
        </div>

        <div style={{ marginTop: 12, textAlign: "center", color: COLORS.fg2, fontSize: 11, display: "flex", alignItems: "center", justifyContent: "center", gap: 6 }}>
          <svg width="28" height="14" viewBox="0 0 28 14" fill="none">
            <circle cx="6" cy="11" r="2" stroke="currentColor"/>
            <circle cx="22" cy="11" r="2" stroke="currentColor"/>
            <path d="M6 9V3M22 9V3M3 5l3-3 3 3M19 5l3-3 3 3" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
          Two-finger swipe up to exit X-Ray
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 3. PROPERTY BADGES showcase — long card with all badge variants and
// the "living object" state vocabulary
// ────────────────────────────────────────────────────────────────
function BadgesScreen() {
  const examples = [
    { tag: "NEW",     state: "shimmer",  title: "New listing",   sub: "Created today · 1428 Magnolia Blvd",  tone: "info" },
    { tag: "HIGHROI", state: "glow",     title: "High-opportunity", sub: "ROI 24% · top 5% Maricopa",       tone: "good" },
    { tag: "MULTI",   state: "pulse",    title: "Overdue lien",  sub: "3 years delinquent · pulsing",       tone: "hot" },
    { tag: "STALE",   state: "crack",    title: "Stale data",    sub: "Last scraped 38 days ago",            tone: "neutral" },
    { tag: "watch",   state: "halo",     title: "On watchlist",  sub: "Soft halo · saved 8 days ago",       tone: "info" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Badges & states" sub="Property as living object"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 20px 16px" }}>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.07, fontWeight: 600, margin: "0 0 8px" }}>All badges</div>
        <div className="surface-card" style={{ padding: 12 }}>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {["HOMESTEAD","MULTI","FLOOD","NOHEIRS","VETERAN","SENIOR","QUICKPAY","HIGHROI","STALE","NEW","OTC","NFT"].map(k => (
              <PropBadge key={k} kind={k}/>
            ))}
          </div>
        </div>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.07, fontWeight: 600, margin: "16px 0 8px" }}>State animations</div>
        {examples.map((ex, i) => (
          <div key={i} className="surface-card" style={{
            padding: 12, marginBottom: 8,
            position: "relative",
            border: ex.state === "halo" ? `1px solid ${COLORS.brand}55` : "none",
            boxShadow: ex.state === "halo"
              ? `var(--shadow-card), 0 0 0 5px ${COLORS.brand}0d`
              : ex.state === "glow"
              ? `var(--shadow-card), 0 0 24px ${COLORS.success}28`
              : "var(--shadow-card)",
            overflow: "hidden",
          }}>
            {/* shimmer overlay */}
            {ex.state === "shimmer" && (
              <div style={{
                position: "absolute", inset: 0,
                background: "linear-gradient(115deg, transparent 30%, rgba(0,198,251,0.20) 50%, transparent 70%)",
                pointerEvents: "none",
              }}/>
            )}
            {ex.state === "crack" && (
              <svg viewBox="0 0 100 100" preserveAspectRatio="none" style={{ position: "absolute", inset: 0, width: "100%", height: "100%", pointerEvents: "none" }}>
                <path d="M20 0 L25 30 L18 55 L28 90" stroke={COLORS.fg2} strokeWidth="0.4" fill="none"/>
                <path d="M70 10 L60 35 L72 70" stroke={COLORS.fg2} strokeWidth="0.3" fill="none"/>
              </svg>
            )}
            {ex.state === "pulse" && (
              <div style={{
                position: "absolute", top: 12, right: 12,
                width: 8, height: 8, borderRadius: "50%",
                background: COLORS.danger,
                boxShadow: `0 0 0 5px ${COLORS.danger}22, 0 0 0 12px ${COLORS.danger}10`,
              }}/>
            )}
            <div style={{ display: "flex", alignItems: "center", gap: 10, position: "relative" }}>
              <div style={{
                width: 40, height: 40, borderRadius: 8,
                background: ex.tone === "info" ? "rgba(0,91,234,0.10)"
                         : ex.tone === "good" ? "rgba(31,182,122,0.12)"
                         : ex.tone === "hot"  ? "rgba(229,72,77,0.10)"
                                              : "rgba(48,63,73,0.08)",
                color: ex.tone === "info" ? COLORS.brand
                     : ex.tone === "good" ? COLORS.success
                     : ex.tone === "hot"  ? COLORS.danger
                                          : COLORS.fg1,
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>{ex.state === "shimmer" ? Ico.sparkle : ex.state === "glow" ? Ico.trend : ex.state === "pulse" ? Ico.warn : ex.state === "crack" ? Ico.refresh : Ico.heart}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{ex.title}</div>
                <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2 }}>{ex.sub}</div>
              </div>
              <div style={{ fontSize: 10, fontFamily: "monospace", color: COLORS.fg2, textTransform: "uppercase" }}>{ex.state}</div>
            </div>
          </div>
        ))}
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 4. SWIPE FOCUS MODE — Tinder card
// ────────────────────────────────────────────────────────────────
function SwipeFocusScreen() {
  return (
    <PhoneScreen dark>
      <TopBar
        title=""
        sub=""
        leading={<button className="icon-btn" style={{ background: "rgba(255,255,255,0.08)", color: "#fff" }}>{Ico.close}</button>}
        trailing={
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <span style={{ fontSize: 12, color: "#fff", opacity: 0.7 }}>23 / 50</span>
            <IconButton label="more"><span style={{ color: "#fff" }}>{Ico.more}</span></IconButton>
          </div>
        }
      />
      <div style={{ flex: 1, padding: "0 18px", position: "relative", background: "#0F1419" }}>
        {/* stacked cards behind */}
        <div style={{
          position: "absolute", top: 12, left: 30, right: 30, height: 460,
          background: "#1A2129", borderRadius: 20, transform: "rotate(-2deg) translateY(8px)",
        }}/>
        <div style={{
          position: "absolute", top: 16, left: 22, right: 22, height: 460,
          background: "#22303C", borderRadius: 22, transform: "rotate(1.5deg) translateY(4px)",
        }}/>

        {/* top card */}
        <div style={{
          position: "relative", marginTop: 6,
          background: "#fff", borderRadius: 22, overflow: "hidden",
          boxShadow: "0 24px 60px rgba(0,0,0,0.4)",
          transform: "rotate(-3deg)",
        }}>
          <PropertyImage height={220} tone="cool" badge={
            <div style={{ position: "absolute", left: 12, top: 12, display: "flex", gap: 6 }}>
              <Badge tone="info">DEED · OTC</Badge>
              <Badge tone="good"><span style={{ fontWeight: 800 }}>↗</span>22%</Badge>
            </div>
          }/>
          <div style={{ padding: "14px 16px 18px" }}>
            <div style={{ fontSize: 18, fontWeight: 600 }}>2840 Hilltop Drive</div>
            <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 2 }}>Orlando, FL · Orange County</div>

            <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
              <StatTile label="Value" value="$67k"/>
              <StatTile label="ROI" value="22%" accent={COLORS.success}/>
              <StatTile label="FVI" value="8.6" accent={COLORS.brand}/>
            </div>

            <div style={{ display: "flex", gap: 6, marginTop: 10, flexWrap: "wrap" }}>
              <PropBadge kind="HIGHROI"/>
              <PropBadge kind="QUICKPAY"/>
              <Badge tone="neutral">3 BR · 2 BA</Badge>
            </div>
          </div>
          {/* swipe affordances overlay */}
          <div style={{
            position: "absolute", top: 24, left: 16, padding: "6px 10px",
            border: `2px solid ${COLORS.success}`, borderRadius: 10,
            color: COLORS.success, fontWeight: 700, fontSize: 13,
            transform: "rotate(-15deg)", opacity: 0.55, letterSpacing: 0.04,
          }}>WATCH</div>
        </div>

        {/* gesture compass */}
        <div style={{
          position: "absolute", bottom: 100, left: 0, right: 0,
          display: "flex", justifyContent: "center", alignItems: "center", gap: 26,
        }}>
          <SwipeBtn label="Pass" color={COLORS.danger} dir="←"/>
          <SwipeBtn label="Later" color={COLORS.warning} dir="↓" sub/>
          <SwipeBtn label="Watch" color={COLORS.success} dir="→" big/>
          <SwipeBtn label="Super" color={COLORS.cyan} dir="↑" sub/>
        </div>

        {/* gesture hint legend */}
        <div style={{
          position: "absolute", bottom: 40, left: 18, right: 18,
          display: "flex", justifyContent: "space-around",
          fontSize: 10, color: "rgba(255,255,255,0.55)",
        }}>
          <span>2-finger ↑ Share</span>
          <span>2-finger ↓ Hide</span>
          <span>Long press: Annotate</span>
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function SwipeBtn({ label, color, dir, big, sub }) {
  const s = big ? 64 : sub ? 44 : 52;
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
      <div style={{
        width: s, height: s, borderRadius: "50%",
        background: big ? `radial-gradient(circle at 30% 30%, ${color} 0%, ${color}cc 100%)` : "rgba(255,255,255,0.08)",
        border: big ? "0" : `1px solid ${color}99`,
        display: "flex", alignItems: "center", justifyContent: "center",
        color: big ? "#fff" : color,
        fontSize: big ? 22 : 18, fontWeight: 700,
        boxShadow: big ? `0 8px 24px ${color}55` : "none",
      }}>{dir}</div>
      <span style={{ fontSize: 11, color: "rgba(255,255,255,0.75)", fontWeight: 500 }}>{label}</span>
    </div>
  );
}

// ────────────────────────────────────────────────────────────────
// 5. COMPARISON BRIDGE — two cards diffed
// ────────────────────────────────────────────────────────────────
function ComparisonScreen() {
  const A = { addr: "1247 Oak Street", city: "Phoenix · Maricopa",
              value: 89000, tax: 12450, roi: 0.185, risk: 32, fvi: 8.2, payback: 8, type: "Residential" };
  const B = { addr: "5602 Palm Ave",   city: "Tucson · Pima",
              value: 64000, tax: 7800, roi: 0.142, risk: 51, fvi: 7.1, payback: 14, type: "Residential" };

  const diff = [
    { k: "Value",   a: usdFull(A.value), b: usdFull(B.value), delta: "+$25k",  positive: true,  metric: "A wins" },
    { k: "Lien",    a: usdFull(A.tax),   b: usdFull(B.tax),   delta: "+$4.6k", positive: false, metric: "Bigger commitment" },
    { k: "ROI",     a: pct(A.roi),       b: pct(B.roi),       delta: "+4.3pp", positive: true,  metric: "A wins" },
    { k: "Risk",    a: `${A.risk}/100`,  b: `${B.risk}/100`,  delta: "−19",    positive: true,  metric: "A lower" },
    { k: "FVI",     a: A.fvi.toFixed(1), b: B.fvi.toFixed(1), delta: "+1.1",   positive: true,  metric: "A wins" },
    { k: "Payback", a: `${A.payback}mo`, b: `${B.payback}mo`, delta: "−6mo",   positive: true,  metric: "A faster" },
    { k: "Type",    a: A.type,           b: B.type,           delta: "match",  positive: null,  metric: "Same" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Compare" sub="2 properties"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="more">{Ico.more}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* Two mini cards w/ a "bridge" between them */}
        <div style={{ position: "relative", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}>
          <CompCard p={A} winner/>
          <CompCard p={B}/>
          {/* bridge */}
          <svg style={{ position: "absolute", left: "50%", top: 100, transform: "translateX(-50%)", pointerEvents: "none" }}
               width="60" height="32" viewBox="0 0 60 32" fill="none">
            <path d="M0 16 H60" stroke={COLORS.brand} strokeWidth="2" strokeDasharray="3 3"/>
            <circle cx="30" cy="16" r="13" fill="#fff" stroke={COLORS.brand} strokeWidth="2"/>
            <text x="30" y="20" textAnchor="middle" fontSize="11" fontWeight="700" fill={COLORS.brand}>vs</text>
          </svg>
        </div>

        {/* diff table */}
        <div className="surface-card" style={{ padding: 14, marginTop: 12 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 6 }}>
            <span style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Differences</span>
            <Badge tone="good">A leads · 5 of 7</Badge>
          </div>
          <div style={{
            display: "grid", gridTemplateColumns: "78px 1fr 1fr auto",
            rowGap: 4, columnGap: 8, alignItems: "center",
            fontSize: 13,
          }}>
            <div style={{ fontSize: 11, color: COLORS.fg2 }}>Field</div>
            <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600 }}>A · Oak St</div>
            <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600 }}>B · Palm Ave</div>
            <div style={{ fontSize: 11, color: COLORS.fg2 }}>Δ</div>
            {diff.map(d => (
              <React.Fragment key={d.k}>
                <div style={{ color: COLORS.fg2, fontSize: 12 }}>{d.k}</div>
                <div style={{ fontWeight: 600, color: d.positive === true ? COLORS.success : COLORS.fg1 }}>{d.a}</div>
                <div style={{ color: d.positive === false ? COLORS.fg1 : COLORS.fg2 }}>{d.b}</div>
                <div style={{
                  fontSize: 11, fontWeight: 600,
                  color: d.positive === true ? COLORS.success
                       : d.positive === false ? COLORS.danger
                                              : COLORS.fg2,
                  fontVariantNumeric: "tabular-nums",
                }}>{d.delta}</div>
              </React.Fragment>
            ))}
          </div>
        </div>

        <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
          <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "12px 12px" }}>Add 3rd</button>
          <button className="cta" style={{ flex: 1.4, fontSize: 13, padding: "12px 12px" }}>Choose A</button>
        </div>

        <div style={{ marginTop: 12, fontSize: 11, color: COLORS.fg2, textAlign: "center" }}>
          Drag cards apart further to expand · pinch to dismiss bridge
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function CompCard({ p, winner }) {
  return (
    <div className="surface-card" style={{
      padding: 10, display: "flex", flexDirection: "column", gap: 8,
      border: winner ? `2px solid ${COLORS.success}` : "0",
      boxShadow: winner ? `var(--shadow-card), 0 0 0 4px ${COLORS.success}12` : "var(--shadow-card)",
    }}>
      <PropertyImage height={94} tone={winner ? "desert" : "cool"} badge={
        winner && (
          <div style={{ position: "absolute", top: 6, right: 6 }}>
            <Badge tone="good"><span style={{ fontWeight: 800 }}>✓</span>Lead</Badge>
          </div>
        )
      }/>
      <div>
        <div style={{ fontSize: 13, fontWeight: 600 }}>{p.addr}</div>
        <div style={{ fontSize: 11, color: COLORS.fg2 }}>{p.city}</div>
      </div>
      <div style={{ display: "flex", gap: 4, fontSize: 11 }}>
        <Badge tone={winner ? "good" : "neutral"}>{pct(p.roi)}</Badge>
        <Badge tone="neutral">{`${p.risk}r`}</Badge>
        <Badge tone="neutral">FVI {p.fvi}</Badge>
      </div>
    </div>
  );
}

Object.assign(window, {
  PropertyImage, PropBadge,
  PropertyDetailScreen, XRayScreen, BadgesScreen,
  SwipeFocusScreen, ComparisonScreen,
});
