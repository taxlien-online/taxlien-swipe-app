// onboarding.jsx — multi-step first-launch flow + permission + tour overlay.

// ─────────────────────────────────────────────────────────────────
// 1. Welcome
// ─────────────────────────────────────────────────────────────────
function OnbWelcomeScreen() {
  return (
    <PhoneScreen>
      <div style={{ flex: 1, display: "flex", flexDirection: "column",
                    padding: "30px 30px 0", position: "relative", overflow: "hidden" }}>
        {/* Hero galaxy decoration */}
        <div style={{
          position: "absolute", top: -40, left: -60, right: -60, height: 380,
          background: "radial-gradient(ellipse at center, rgba(0,198,251,0.18) 0%, rgba(0,91,234,0.06) 35%, transparent 70%)",
          pointerEvents: "none",
        }}/>
        <svg style={{ position: "absolute", top: 30, left: 30, right: 30 }} width="332" height="280" viewBox="0 0 332 280">
          {Array.from({length: 40}).map((_,i) => {
            const seed = i * 137;
            const x = 20 + ((seed * 17) % 290);
            const y = 30 + ((seed * 23) % 220);
            const r = 2 + ((seed * 7) % 8);
            const c = ["#00C6FB","#005BEA","#1FB67A","#FFB020"][i%4];
            return <circle key={i} cx={x} cy={y} r={r} fill={c} opacity={0.55 + (i%3)*0.15}/>;
          })}
          <circle cx="170" cy="140" r="22" fill="url(#g1)" opacity="0.9"/>
          <defs>
            <radialGradient id="g1"><stop offset="0" stopColor="#00C6FB"/><stop offset="1" stopColor="#005BEA"/></radialGradient>
          </defs>
        </svg>

        <div style={{ marginTop: 280, position: "relative" }}>
          <div style={{ fontSize: 11, color: COLORS.brand, fontWeight: 700,
                        letterSpacing: 0.10, textTransform: "uppercase" }}>Tax Lien Galaxy</div>
          <div style={{ fontSize: 28, fontWeight: 700, color: COLORS.fg1,
                        letterSpacing: -0.01, lineHeight: 1.15, marginTop: 8 }}>
            Find tax-advantaged real estate before anyone else.
          </div>
          <div style={{ fontSize: 14, color: COLORS.fg2, lineHeight: 1.4, marginTop: 10 }}>
            Spatial intelligence for tax liens, deeds and foreclosures. We surface high-yield, low-competition opportunities so you can act before the auction.
          </div>
        </div>

        <div style={{ flex: 1 }}/>

        <div style={{ display: "flex", flexDirection: "column", gap: 8, padding: "12px 0 14px" }}>
          <button className="cta" style={{ width: "100%", padding: "16px 18px", fontSize: 15 }}>Start tour</button>
          <button className="cta cta--ghost" style={{ width: "100%", padding: "14px 18px", fontSize: 14 }}>I've used it before · skip</button>
          <div style={{ fontSize: 11, color: COLORS.fg2, textAlign: "center", marginTop: 4 }}>
            By continuing you accept the Terms of Service and Privacy Policy.
          </div>
        </div>
      </div>
    </PhoneScreen>
  );
}

// ─────────────────────────────────────────────────────────────────
// 2. Pick a persona
// ─────────────────────────────────────────────────────────────────
function OnbPersonaScreen() {
  return (
    <PhoneScreen>
      <TopBar title="Step 1 of 4" sub="Pick a strategy"/>
      <div style={{ flex: 1, padding: "0 24px", display: "flex", flexDirection: "column" }}>
        <ProgressDots step={0}/>

        <div style={{ fontSize: 22, fontWeight: 700, marginTop: 18, color: COLORS.fg1, letterSpacing: -0.01 }}>
          Which investor are you?
        </div>
        <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 4, lineHeight: 1.4 }}>
          We'll preset filters, dimensions, and Sweet Spot weights. You can change this anytime.
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10, marginTop: 18 }}>
          {PERSONAS.map((p, i) => (
            <div key={p.id} style={{
              padding: 14, borderRadius: 14, position: "relative",
              background: i === 0 ? "var(--surface)" : "var(--surface)",
              border: i === 0 ? `2px solid ${p.color}` : "1px solid var(--line)",
              boxShadow: i === 0 ? `0 8px 22px ${p.color}26` : "var(--shadow-card)",
            }}>
              {i === 0 && (
                <div style={{
                  position: "absolute", top: 10, right: 10,
                  width: 18, height: 18, borderRadius: "50%",
                  background: p.color, color: "#fff",
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 10, fontWeight: 700,
                }}>✓</div>
              )}
              <div style={{
                width: 32, height: 32, borderRadius: 10, background: p.soft,
                color: p.color, display: "flex", alignItems: "center", justifyContent: "center",
                marginBottom: 10,
              }}>{p.icon}</div>
              <div style={{ fontSize: 15, fontWeight: 700, color: COLORS.fg1 }}>{p.full}</div>
              <div style={{ fontSize: 11, color: COLORS.fg2, marginTop: 4, lineHeight: 1.3 }}>{p.desc}</div>
            </div>
          ))}
        </div>

        <div style={{ flex: 1 }}/>
        <div style={{ display: "flex", gap: 8, padding: "12px 0 16px" }}>
          <button className="cta cta--ghost" style={{ flex: 1, padding: "14px", fontSize: 14 }}>Back</button>
          <button className="cta" style={{ flex: 2, padding: "14px", fontSize: 14 }}>Continue · Flipper</button>
        </div>
      </div>
    </PhoneScreen>
  );
}

function ProgressDots({ step }) {
  return (
    <div style={{ display: "flex", gap: 6, marginTop: 4 }}>
      {[0,1,2,3].map(i => (
        <div key={i} style={{
          flex: i === step ? 2 : 1, height: 4, borderRadius: 2,
          background: i <= step ? "var(--brand-gradient)" : "var(--disabled)",
          transition: "all 200ms",
        }}/>
      ))}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────────
// 3. Jurisdictions (states + counties)
// ─────────────────────────────────────────────────────────────────
function OnbJurisdictionsScreen() {
  const states = [
    { code: "FL", name: "Florida",   counties: 67, picked: true,  intRate: "18%" },
    { code: "AZ", name: "Arizona",   counties: 15, picked: true,  intRate: "16%" },
    { code: "TX", name: "Texas",     counties: 254, picked: false, intRate: "25%" },
    { code: "IL", name: "Illinois",  counties: 102, picked: true,  intRate: "18%" },
    { code: "MD", name: "Maryland",  counties: 24, picked: false, intRate: "20%" },
    { code: "IA", name: "Iowa",      counties: 99, picked: false, intRate: "24%" },
    { code: "OH", name: "Ohio",      counties: 88, picked: false, intRate: "18%" },
    { code: "CO", name: "Colorado",  counties: 64, picked: false, intRate: "15%" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Step 2 of 4" sub="Jurisdictions"/>
      <div style={{ flex: 1, padding: "0 24px", display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <ProgressDots step={1}/>

        <div style={{ fontSize: 22, fontWeight: 700, marginTop: 18, letterSpacing: -0.01 }}>
          Where are you investing?
        </div>
        <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 4, lineHeight: 1.4 }}>
          Pick states first. You can drill into counties later. Florida is a popular start for beginners.
        </div>

        <div style={{ marginTop: 14, position: "relative" }}>
          <div style={{
            background: "var(--bg)", borderRadius: 12, padding: "10px 12px",
            display: "flex", alignItems: "center", gap: 8,
            border: "1px solid var(--line)",
          }}>
            <span style={{ color: COLORS.fg2 }}>{Ico.search}</span>
            <span style={{ fontSize: 14, color: COLORS.fg2 }}>Search states or counties…</span>
          </div>
        </div>

        <div style={{ flex: 1, marginTop: 12, overflow: "auto", marginRight: -10, paddingRight: 10 }}>
          {states.map(s => (
            <div key={s.code} style={{
              display: "flex", alignItems: "center", gap: 12,
              padding: "12px 8px", borderRadius: 10,
              background: s.picked ? "rgba(0,91,234,0.04)" : "transparent",
              marginBottom: 4,
            }}>
              <div style={{
                width: 40, height: 30, borderRadius: 4,
                background: `linear-gradient(135deg, ${["#005BEA","#00C6FB","#1FB67A","#FFB020"][s.code.charCodeAt(0)%4]}, ${["#7B5BEA","#005BEA","#0EA5C7","#E25A1A"][s.code.charCodeAt(0)%4]})`,
                display: "flex", alignItems: "center", justifyContent: "center",
                color: "#fff", fontSize: 11, fontWeight: 700, letterSpacing: 0.04,
              }}>{s.code}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 15, fontWeight: 600 }}>{s.name}</div>
                <div style={{ fontSize: 11, color: COLORS.fg2 }}>{s.counties} counties · max {s.intRate} int.</div>
              </div>
              <div style={{
                width: 22, height: 22, borderRadius: 6,
                background: s.picked ? COLORS.brand : "transparent",
                border: s.picked ? "0" : "1.5px solid var(--fg-2)",
                display: "flex", alignItems: "center", justifyContent: "center",
                color: "#fff",
              }}>{s.picked && <svg width="14" height="14" viewBox="0 0 14 14"><path d="M3 7l3 3 5-6" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>}</div>
            </div>
          ))}
        </div>

        <div style={{ padding: "12px 0 16px" }}>
          <div style={{ fontSize: 12, color: COLORS.fg2, textAlign: "center", marginBottom: 8 }}>
            3 states selected · 184 counties · ~5,400 active liens
          </div>
          <div style={{ display: "flex", gap: 8 }}>
            <button className="cta cta--ghost" style={{ flex: 1, padding: "14px", fontSize: 14 }}>Back</button>
            <button className="cta" style={{ flex: 2, padding: "14px", fontSize: 14 }}>Continue</button>
          </div>
        </div>
      </div>
    </PhoneScreen>
  );
}

// ─────────────────────────────────────────────────────────────────
// 4. Permissions (location + notifications + biometrics)
// ─────────────────────────────────────────────────────────────────
function OnbPermissionsScreen() {
  const perms = [
    { id: "loc", icon: Ico.map,    title: "Use your location",
      desc: "Sort properties by distance · highlight nearby auctions",
      cta: "Allow", color: COLORS.brand, allowed: true },
    { id: "noti", icon: Ico.bolt,  title: "Push notifications",
      desc: "Auction starts, redemption deadlines, watchlist alerts",
      cta: "Allow", color: COLORS.warning, allowed: true },
    { id: "bio", icon: Ico.shield, title: "Face ID for buys",
      desc: "Required to confirm any bid · OTC purchase · capital movement",
      cta: "Enable", color: COLORS.success, allowed: false },
    { id: "cal", icon: Ico.cal,    title: "Calendar access",
      desc: "Drop auction dates into your calendar",
      cta: "Allow", color: COLORS.purple, allowed: false },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Step 3 of 4" sub="Permissions"/>
      <div style={{ flex: 1, padding: "0 24px", display: "flex", flexDirection: "column" }}>
        <ProgressDots step={2}/>

        <div style={{ fontSize: 22, fontWeight: 700, marginTop: 18, letterSpacing: -0.01 }}>
          We need a few permissions.
        </div>
        <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 4, lineHeight: 1.4 }}>
          You can change all of these later in Settings · Privacy.
        </div>

        <div style={{ marginTop: 18, display: "flex", flexDirection: "column", gap: 10 }}>
          {perms.map(p => (
            <div key={p.id} className="surface-card" style={{ padding: 14, display: "flex", alignItems: "center", gap: 12 }}>
              <div style={{
                width: 40, height: 40, borderRadius: 10,
                background: p.color + "1c", color: p.color,
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>{p.icon}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{p.title}</div>
                <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2, lineHeight: 1.35 }}>{p.desc}</div>
              </div>
              <button style={{
                padding: "8px 12px", fontSize: 12, fontWeight: 600,
                borderRadius: 8, border: 0, cursor: "pointer",
                background: p.allowed ? "var(--success)" : "var(--bg)",
                color: p.allowed ? "#fff" : COLORS.brand,
                whiteSpace: "nowrap",
              }}>{p.allowed ? "✓ Allowed" : p.cta}</button>
            </div>
          ))}
        </div>

        <div style={{ flex: 1 }}/>
        <div style={{ display: "flex", gap: 8, padding: "12px 0 16px" }}>
          <button className="cta cta--ghost" style={{ flex: 1, padding: "14px", fontSize: 14 }}>Skip</button>
          <button className="cta" style={{ flex: 2, padding: "14px", fontSize: 14 }}>Continue</button>
        </div>
      </div>
    </PhoneScreen>
  );
}

// ─────────────────────────────────────────────────────────────────
// 5. In-app tour spotlight overlay (on Galaxy)
// ─────────────────────────────────────────────────────────────────
function OnbTourScreen() {
  const points = layoutFor("roi");
  return (
    <PhoneScreen>
      <div style={{ position: "absolute", inset: 0, opacity: 0.85 }}>
        <TopBar title="Galaxy" sub="847 properties"
          trailing={<React.Fragment><IconButton label="filter">{Ico.filter}</IconButton><IconButton label="ai" accent>{Ico.ai}</IconButton></React.Fragment>}
        />
        <div className="galaxy" style={{ position: "relative" }}>
          {points.map(p => <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size} color={p.color}/>)}
        </div>
        <div style={{ height: 100 }}/>
        <BottomNav active="galaxy"/>
      </div>

      {/* dark scrim with cutout */}
      <svg style={{ position: "absolute", inset: 0, pointerEvents: "none", zIndex: 5 }}
           width="100%" height="100%">
        <defs>
          <mask id="cutout">
            <rect width="100%" height="100%" fill="white"/>
            <circle cx="200" cy="320" r="100" fill="black"/>
          </mask>
        </defs>
        <rect width="100%" height="100%" fill="rgba(15,20,25,0.55)" mask="url(#cutout)"/>
        {/* glowing ring around cutout */}
        <circle cx="200" cy="320" r="102" stroke="#00C6FB" strokeWidth="2" fill="none" opacity="0.9"/>
        <circle cx="200" cy="320" r="116" stroke="#00C6FB" strokeWidth="1" fill="none" opacity="0.4"/>
      </svg>

      {/* tour callout */}
      <div style={{
        position: "absolute", left: 24, right: 24, top: 460, zIndex: 6,
      }}>
        <div className="floatpanel" style={{ padding: 16 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
            <span style={{
              fontSize: 11, fontWeight: 700, color: COLORS.brand,
              textTransform: "uppercase", letterSpacing: 0.08,
            }}>Step 4 of 4 · Tour</span>
            <ProgressDots step={3}/>
          </div>
          <div style={{ fontSize: 17, fontWeight: 700, color: COLORS.fg1, letterSpacing: -0.01 }}>
            This is your Galaxy.
          </div>
          <div style={{ fontSize: 13, color: COLORS.fg2, marginTop: 6, lineHeight: 1.4 }}>
            Every dot is a property. Size = value, color = ROI. Pinch to zoom, lasso to select, rotate two fingers to switch dimension.
          </div>
          <div style={{ display: "flex", gap: 8, marginTop: 14 }}>
            <button className="cta cta--ghost" style={{ flex: 1, padding: "12px", fontSize: 13 }}>Skip tour</button>
            <button className="cta" style={{ flex: 2, padding: "12px", fontSize: 13 }}>Next · Lasso →</button>
          </div>
        </div>
      </div>
    </PhoneScreen>
  );
}

Object.assign(window, {
  OnbWelcomeScreen, OnbPersonaScreen, OnbJurisdictionsScreen,
  OnbPermissionsScreen, OnbTourScreen,
});
