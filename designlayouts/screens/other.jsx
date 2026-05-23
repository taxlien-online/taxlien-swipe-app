// other.jsx — AI Copilot, List, Watchlist, Profile, Galaxy with query results

// ────────────────────────────────────────────────────────────────
// 1. AI COPILOT — collapsed pill state (above bottom nav)
// ────────────────────────────────────────────────────────────────
function CopilotCollapsedScreen() {
  const points = layoutFor("roi");
  return (
    <PhoneScreen>
      <TopBar title="Galaxy" sub="847 properties"
        trailing={
          <React.Fragment>
            <IconButton label="filter">{Ico.filter}</IconButton>
            <IconButton label="ai" accent>{Ico.ai}</IconButton>
          </React.Fragment>
        }
      />
      <div className="galaxy">
        {points.map(p => (
          <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*0.85} color={p.color}/>
        ))}
      </div>
      {/* Copilot pill */}
      <div style={{ padding: "10px 16px 16px" }}>
        <div style={{
          display: "flex", alignItems: "center", gap: 10,
          padding: "10px 12px 10px 14px",
          background: "var(--surface)",
          border: "1px solid var(--line)",
          borderRadius: 999,
          boxShadow: "0 4px 16px rgba(20,35,50,0.08), var(--shadow-card)",
        }}>
          <div style={{
            width: 28, height: 28, borderRadius: "50%",
            background: "var(--brand-gradient)", color: "#fff",
            display: "flex", alignItems: "center", justifyContent: "center",
            flexShrink: 0,
          }}>{Ico.ai}</div>
          <span style={{ color: COLORS.fg2, fontSize: 14, flex: 1 }}>Ask: “Show high ROI in Florida”</span>
          <div style={{
            width: 30, height: 30, borderRadius: "50%",
            background: "rgba(0,91,234,0.10)", color: COLORS.brand,
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>{Ico.mic}</div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 2. AI COPILOT — expanded bottom sheet
// ────────────────────────────────────────────────────────────────
function CopilotExpandedScreen() {
  const points = layoutFor("roi");
  const recent = [
    "liens under $10k in Arizona",
    "homesteaded properties with high ROI",
    "no heirs properties · 3+ years delinquent",
  ];
  const suggestions = [
    { label: "OTC deals · now", tone: "good" },
    { label: "Auctions next week", tone: "warn" },
    { label: "Best counties for liens", tone: "info" },
    { label: "Veteran-owned · skip", tone: "purple" },
    { label: "Zillow 30% above assess.", tone: "good" },
    { label: "Expiring redemption", tone: "hot" },
  ];

  return (
    <PhoneScreen>
      {/* dimmed background */}
      <div style={{ flex: 1, position: "relative" }}>
        <div style={{ position: "absolute", inset: 0, opacity: 0.4, filter: "blur(2px)" }}>
          <TopBar title="Galaxy" sub="847 properties" trailing={<IconButton label="ai" accent>{Ico.ai}</IconButton>}/>
          <div className="galaxy" style={{ margin: "0 16px" }}>
            {points.map(p => (
              <GalaxyDot key={p.id} x={p.x} y={p.y} size={p.size*0.8} color={p.color}/>
            ))}
          </div>
        </div>
        <div style={{ position: "absolute", inset: 0, background: "rgba(15,20,25,0.32)" }}/>
      </div>

      {/* sheet */}
      <div style={{
        position: "absolute", left: 0, right: 0, bottom: 34,
        background: "var(--surface)",
        borderTopLeftRadius: 24, borderTopRightRadius: 24,
        boxShadow: "0 -8px 32px rgba(20,35,50,0.18)",
        padding: "12px 16px 20px",
      }}>
        {/* drag handle */}
        <div style={{
          width: 38, height: 4, borderRadius: 4, background: "var(--disabled)",
          margin: "0 auto 12px",
        }}/>

        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 12 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <div style={{
              width: 32, height: 32, borderRadius: "50%",
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.ai}</div>
            <div>
              <div style={{ fontSize: 15, fontWeight: 600 }}>Deal Copilot</div>
              <div style={{ fontSize: 11, color: COLORS.fg2 }}>Natural-language query</div>
            </div>
          </div>
          <IconButton label="close">{Ico.close}</IconButton>
        </div>

        {/* input */}
        <div style={{
          background: "var(--bg)", borderRadius: 14, padding: 12,
          border: `1px solid ${COLORS.brand}33`,
          boxShadow: `0 0 0 4px ${COLORS.brand}08`,
        }}>
          <div style={{ fontSize: 15, color: COLORS.fg1, lineHeight: 1.4 }}>
            Show tax deeds in Maricopa with ROI above 15% and low risk
            <span style={{ display: "inline-block", width: 1, height: 16, background: COLORS.brand, marginLeft: 2, verticalAlign: "middle", animation: "blink 1s steps(2) infinite" }}/>
          </div>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 8 }}>
            <div style={{ display: "flex", gap: 6, color: COLORS.fg2, fontSize: 12, alignItems: "center" }}>
              {Ico.mic}<span>Listening…</span>
            </div>
            <button className="cta" style={{ padding: "8px 14px", fontSize: 13 }}>Run query</button>
          </div>
        </div>

        {/* recent */}
        <div style={{ marginTop: 14 }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginBottom: 6 }}>Recent</div>
          {recent.map((r, i) => (
            <div key={i} style={{
              display: "flex", alignItems: "center", gap: 10, padding: "8px 0",
              borderBottom: i < recent.length - 1 ? "1px solid var(--line)" : "none",
              fontSize: 14, color: COLORS.fg1,
            }}>
              <span style={{ color: COLORS.fg2 }}>{Ico.clock}</span>
              <span style={{ flex: 1 }}>{r}</span>
              <span style={{ color: COLORS.fg2, fontSize: 12 }}>→</span>
            </div>
          ))}
        </div>

        {/* suggestions */}
        <div style={{ marginTop: 14 }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginBottom: 6 }}>Try</div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {suggestions.map(s => (
              <Badge key={s.label} tone={s.tone}>{s.label}</Badge>
            ))}
          </div>
        </div>
      </div>
      <style>{`@keyframes blink { 50% { opacity: 0; } }`}</style>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 3. AI COPILOT — query result highlighted in galaxy
// ────────────────────────────────────────────────────────────────
function CopilotResultScreen() {
  const points = layoutFor("roi");
  // Highlight: state=FL, roi>0.15, risk<60
  const matched = new Set(
    PROPERTIES
      .filter(p => p.state === "FL" && p.roi >= 0.15 && p.risk < 60)
      .map(p => p.id)
  );

  return (
    <PhoneScreen>
      <TopBar
        title="23 matches"
        sub="Florida · ROI ≥ 15% · low risk"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={
          <React.Fragment>
            <IconButton label="ai" accent>{Ico.ai}</IconButton>
            <IconButton label="more">{Ico.more}</IconButton>
          </React.Fragment>
        }
      />
      <div className="galaxy">
        {/* dim */}
        <div className="hud" style={{ top: 12, left: 12 }}>
          <span className="hud__dot" style={{ background: COLORS.success }}/>
          {Ico.trend}<span>ROI</span>
        </div>
        <div className="hud" style={{ top: 12, right: 12, color: COLORS.brand, fontWeight: 600 }}>
          {Ico.ai}<span>AI filter</span>
        </div>

        {points.map(p => {
          const on = matched.has(p.id);
          return (
            <GalaxyDot key={p.id} x={p.x} y={p.y}
                       size={on ? p.size*1.1 : p.size*0.85}
                       color={on ? p.color : COLORS.fg2}
                       opacity={on ? 1 : 0.18}
                       halo={on}/>
          );
        })}
      </div>

      {/* response card */}
      <div style={{ padding: "10px 16px 12px" }}>
        <div className="floatpanel" style={{ padding: 14 }}>
          <div style={{ display: "flex", alignItems: "flex-start", gap: 10, marginBottom: 10 }}>
            <div style={{
              width: 28, height: 28, borderRadius: "50%", flexShrink: 0,
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.ai}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, color: COLORS.fg1, lineHeight: 1.4 }}>
                Found <b>23 properties</b> in Florida with ROI above 15% and risk below 60. Cluster concentrated in Duval and Orange counties.
              </div>
            </div>
          </div>
          <div style={{ display: "flex", gap: 6, marginBottom: 10 }}>
            <Badge tone="good">Avg ROI 17.3%</Badge>
            <Badge tone="info">19 low risk</Badge>
            <Badge tone="warn">4 medium</Badge>
          </div>
          <div style={{ display: "flex", gap: 8 }}>
            <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "11px 12px" }}>View list</button>
            <button className="cta" style={{ flex: 1.2, fontSize: 13, padding: "11px 12px" }}>Watchlist all</button>
          </div>
        </div>
      </div>
      <BottomNav active="galaxy"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 4. LIST view (fallback)
// ────────────────────────────────────────────────────────────────
function ListScreen() {
  const items = PROPERTIES.slice(0, 9).map(p => ({
    ...p,
    badges: [
      p.homestead && "HOMESTEAD",
      p.priorY >= 3 && "MULTI",
      p.flood !== "Zone X" && "FLOOD",
      p.noHeirs && "NOHEIRS",
      p.veteran && "VETERAN",
      p.senior && "SENIOR",
      p.payback <= 6 && "QUICKPAY",
      p.roi >= 0.20 && "HIGHROI",
      p.stale && "STALE",
      p.newListing && "NEW",
    ].filter(Boolean),
  }));

  return (
    <PhoneScreen>
      <TopBar title="All liens"
        sub="847 · sorted by ROI"
        trailing={
          <React.Fragment>
            <IconButton label="search">{Ico.search}</IconButton>
            <IconButton label="filter">{Ico.filter}</IconButton>
          </React.Fragment>
        }
      />

      {/* sort/filter strip */}
      <div style={{ padding: "0 20px 8px", display: "flex", gap: 6, overflowX: "auto" }}>
        {[
          { l: "All", a: true }, { l: "Liens" }, { l: "Deeds" }, { l: "Foreclosures" },
          { l: "OTC" }, { l: "Pre-auction" }, { l: "Homestead" },
        ].map(c => (
          <span key={c.l} style={{
            padding: "6px 12px", borderRadius: 999,
            background: c.a ? "var(--brand-gradient)" : "var(--surface)",
            color: c.a ? "#fff" : COLORS.fg1,
            fontSize: 12, fontWeight: 600, whiteSpace: "nowrap",
            border: c.a ? "0" : "1px solid var(--line)",
            boxShadow: c.a ? "none" : "0 1px 4px rgba(48,63,73,0.05)",
          }}>{c.l}</span>
        ))}
      </div>

      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {items.map((p, i) => (
          <ListRow key={p.id} p={p} first={i===0}/>
        ))}
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function ListRow({ p, first }) {
  const tone = p.stage === "pre-auction" ? "warn"
            : p.stage === "otc" ? "cyan"
            : p.stage === "sold" ? "neutral"
            : "info";
  const stageLabel = { "pre-auction":"PRE", listed:"LIEN", otc:"OTC", sold:"SOLD" }[p.stage];
  return (
    <div className="surface-card" style={{
      padding: 12, marginTop: first ? 0 : 8,
      display: "flex", gap: 12, alignItems: "center",
    }}>
      <div style={{
        width: 56, height: 56, borderRadius: 8,
        background: "linear-gradient(135deg, #E8DCC5, #B89F7E)",
        position: "relative", flexShrink: 0, overflow: "hidden",
      }}>
        <svg viewBox="0 0 56 56" style={{ position: "absolute", inset: 0 }}>
          <path d="M0 45 L18 30 L36 40 L56 30 L56 56 L0 56 Z" fill="rgba(48,63,73,0.5)"/>
          <rect x="24" y="36" width="3" height="4" fill="rgba(255,247,220,0.8)"/>
        </svg>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          <Badge tone={tone}>{stageLabel}</Badge>
          {p.priorY >= 3 && <Badge tone="hot"><span style={{ fontWeight: 800 }}>!</span></Badge>}
          {p.roi >= 0.20 && <Badge tone="good"><span style={{ fontWeight: 800 }}>↗</span></Badge>}
          {p.homestead && <Badge tone="purple"><span style={{ fontWeight: 800 }}>♡</span></Badge>}
          {p.newListing && <Badge tone="info"><span style={{ fontWeight: 800 }}>✦</span></Badge>}
        </div>
        <div style={{ fontSize: 14, fontWeight: 600, marginTop: 4, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{p.address}</div>
        <div style={{ fontSize: 12, color: COLORS.fg2 }}>{p.city}, {p.state} · {p.county}</div>
      </div>
      <div style={{ textAlign: "right" }}>
        <div style={{ fontSize: 15, fontWeight: 700, letterSpacing: -0.01 }}>{usd(p.tax)}</div>
        <div style={{ fontSize: 12, color: p.roi >= 0.15 ? COLORS.success : COLORS.fg2, fontWeight: 600 }}>{pct(p.roi)} ROI</div>
        <div style={{ fontSize: 10, color: COLORS.fg2, marginTop: 2 }}>FVI {p.fvi.toFixed(1)}</div>
      </div>
    </div>
  );
}

// ────────────────────────────────────────────────────────────────
// 5. WATCHLIST
// ────────────────────────────────────────────────────────────────
function WatchlistScreen() {
  // Family / collaboration angle: boards
  const items = PROPERTIES.filter(p => p.roi >= 0.16).slice(0, 4);

  return (
    <PhoneScreen>
      <TopBar title="Watchlist"
        sub="3 boards · 24 properties"
        trailing={
          <IconButton label="add">{Ico.plus}</IconButton>
        }
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 20px 12px" }}>

        {/* boards */}
        <div style={{ display: "flex", gap: 8, overflowX: "auto", marginBottom: 14, paddingBottom: 4 }}>
          {[
            { name: "Florida picks", count: 12, accent: COLORS.brand, active: true },
            { name: "Family shared", count: 8,  accent: COLORS.purple },
            { name: "Quick flips",   count: 4,  accent: COLORS.success },
          ].map(b => (
            <div key={b.name} style={{
              flexShrink: 0, padding: 12, borderRadius: 12,
              minWidth: 140,
              background: b.active ? "var(--brand-gradient)" : "var(--surface)",
              color: b.active ? "#fff" : COLORS.fg1,
              boxShadow: b.active ? "0 8px 20px rgba(0,91,234,0.25)" : "var(--shadow-card)",
            }}>
              <div style={{ fontSize: 11, opacity: 0.75, textTransform: "uppercase", fontWeight: 600, letterSpacing: 0.06 }}>Board</div>
              <div style={{ fontSize: 15, fontWeight: 700, marginTop: 2 }}>{b.name}</div>
              <div style={{ fontSize: 11, opacity: 0.85, marginTop: 4 }}>{b.count} properties</div>
            </div>
          ))}
        </div>

        {/* summary */}
        <div className="surface-card" style={{ padding: 12, marginBottom: 12 }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600 }}>Florida picks · totals</div>
          <div style={{ display: "flex", gap: 8, marginTop: 8 }}>
            <StatTile label="Capital" value="$248k"/>
            <StatTile label="Avg ROI" value="18.4%" accent={COLORS.success}/>
            <StatTile label="Auctions" value="6" sub="next 30d" accent={COLORS.warning}/>
          </div>
        </div>

        {items.map((p, i) => (
          <div key={p.id} className="surface-card" style={{ padding: 12, marginTop: i === 0 ? 0 : 8, position: "relative" }}>
            <div style={{
              position: "absolute", left: 0, top: 0, bottom: 0, width: 3,
              background: COLORS.brand, borderTopLeftRadius: 10, borderBottomLeftRadius: 10,
            }}/>
            <div style={{ display: "flex", gap: 10, alignItems: "center" }}>
              <div style={{
                width: 44, height: 44, borderRadius: 22,
                background: `radial-gradient(circle, ${COLORS.brand}22 0%, transparent 70%)`,
                display: "flex", alignItems: "center", justifyContent: "center",
                color: COLORS.brand,
              }}>{Ico.heartF}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{p.address}</div>
                <div style={{ fontSize: 12, color: COLORS.fg2 }}>{p.city}, {p.state}</div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div style={{ fontSize: 14, fontWeight: 700 }}>{usd(p.tax)}</div>
                <div style={{ fontSize: 12, color: COLORS.success, fontWeight: 600 }}>{pct(p.roi)}</div>
              </div>
            </div>
            <div style={{ display: "flex", gap: 4, marginTop: 8, flexWrap: "wrap" }}>
              <Badge tone="info">Auction in {Math.abs(p.auctionDays) || 14}d</Badge>
              {p.roi >= 0.20 && <PropBadge kind="HIGHROI"/>}
              {p.priorY >= 2 && <Badge tone="warn">{p.priorY}yr delinquent</Badge>}
              <Badge tone="purple">3 notes</Badge>
            </div>
          </div>
        ))}
      </div>
      <BottomNav active="watchlist"/>
    </PhoneScreen>
  );
}

// ────────────────────────────────────────────────────────────────
// 6. PROFILE
// ────────────────────────────────────────────────────────────────
function ProfileScreen() {
  const settings = [
    { group: "Account", rows: [
      { k: "Role",         v: "Investor",       hint: true },
      { k: "Jurisdictions",v: "5 selected" },
      { k: "Subscription", v: "Pro · annual",   accent: true },
    ]},
    { group: "Discovery", rows: [
      { k: "Default dimension", v: "ROI" },
      { k: "Galaxy density",    v: "Cluster < 20px" },
      { k: "AI Copilot",        v: "Cloud",       toggle: true },
      { k: "X-Ray on tap",      v: "Off",         toggle: false },
    ]},
    { group: "Ethics filter", rows: [
      { k: "Hide veteran-owned",   v: "On",   toggle: true },
      { k: "Hide senior-owned",    v: "Off",  toggle: false },
      { k: "Hide disability-flagged", v: "On", toggle: true },
    ]},
    { group: "About", rows: [
      { k: "Version", v: "2.0 · dev" },
      { k: "Data freshness", v: "Updated 14 min ago", accent: true },
      { k: "Support", v: "" },
    ]},
  ];

  return (
    <PhoneScreen>
      <TopBar title="Profile" sub="Anton K. · Phoenix, AZ"
        trailing={<IconButton label="more">{Ico.more}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 20px 16px" }}>

        {/* portfolio summary card */}
        <div className="surface-card" style={{
          padding: 16,
          background: "linear-gradient(180deg, #E6F8FF 0%, #E6EEFD 100%)",
          border: `1px solid ${COLORS.brand}22`,
        }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <div>
              <div style={{ fontSize: 11, color: COLORS.brand, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 700 }}>Portfolio</div>
              <div style={{ fontSize: 26, fontWeight: 700, letterSpacing: -0.01, marginTop: 4 }}>$184,200</div>
              <div style={{ fontSize: 12, color: COLORS.success, marginTop: 2, fontWeight: 600 }}>+$4,830 last 30d · 14 active liens</div>
            </div>
            <div style={{
              width: 56, height: 56, borderRadius: "50%",
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              boxShadow: "0 8px 20px rgba(0,91,234,0.25)",
              fontWeight: 700, fontSize: 22,
            }}>AK</div>
          </div>
          <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
            <StatTile label="Avg ROI"  value="15.4%" accent={COLORS.success}/>
            <StatTile label="Redeemed" value="9 / 14" accent={COLORS.brand}/>
            <StatTile label="Deeds"    value="2" sub="acquired"/>
          </div>
        </div>

        {settings.map(s => (
          <div key={s.group} style={{ marginTop: 16 }}>
            <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginBottom: 6, padding: "0 4px" }}>{s.group}</div>
            <div className="surface-card" style={{ padding: "0 14px" }}>
              {s.rows.map((r, i) => (
                <div key={r.k} style={{
                  display: "flex", alignItems: "center", padding: "12px 0",
                  borderBottom: i < s.rows.length - 1 ? "1px solid var(--line)" : "none",
                  fontSize: 15,
                }}>
                  <span style={{ flex: 1, color: COLORS.fg1 }}>{r.k}</span>
                  {r.toggle !== undefined ? (
                    <FakeSwitch on={r.toggle}/>
                  ) : (
                    <span style={{
                      color: r.accent ? COLORS.brand : COLORS.fg2,
                      fontWeight: r.accent ? 600 : 400, marginRight: r.hint ? 6 : 0,
                    }}>{r.v}</span>
                  )}
                  {r.toggle === undefined && (
                    <svg width="8" height="14" viewBox="0 0 8 14" style={{ marginLeft: 8 }}>
                      <path d="M1 1l5 6-5 6" stroke={COLORS.fg2} strokeWidth="1.5" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

function FakeSwitch({ on }) {
  return (
    <div style={{
      width: 44, height: 26, borderRadius: 999,
      background: on ? COLORS.brand : "var(--disabled)",
      position: "relative", transition: "background 150ms",
    }}>
      <div style={{
        position: "absolute", top: 2, left: on ? 20 : 2,
        width: 22, height: 22, borderRadius: "50%", background: "#fff",
        boxShadow: "0 2px 4px rgba(0,0,0,0.15)",
      }}/>
    </div>
  );
}

Object.assign(window, {
  CopilotCollapsedScreen, CopilotExpandedScreen, CopilotResultScreen,
  ListScreen, ListRow, WatchlistScreen, ProfileScreen,
});
