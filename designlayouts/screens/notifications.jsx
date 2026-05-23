// notifications.jsx — iOS lock-screen notifications + in-app inbox +
// desktop tray dropdown.

// ──────────────────────────────────────────────────────────────────
// 1. iOS lock-screen notifications
// ──────────────────────────────────────────────────────────────────
function NotifLockScreen() {
  const notifs = [
    {
      app: "Tax Lien Galaxy", time: "now",
      title: "Auction starts in 30 min",
      body: "Maricopa County · 142 liens · 18% max interest. Tap to join.",
      color: COLORS.danger, badge: "AUCTION", urgent: true,
    },
    {
      app: "Tax Lien Galaxy", time: "8m ago",
      title: "Watchlist: 1247 Oak St redeemed",
      body: "Owner paid the lien. You earned $1,994 (16% APR). Funds available.",
      color: COLORS.success, badge: "PAYOUT",
    },
    {
      app: "Tax Lien Galaxy", time: "23m ago",
      title: "New match for your Flipper strategy",
      body: "4 OTC liens in Duval, FL · avg 22% ROI · 3-day window.",
      color: COLORS.brand, badge: "AI",
    },
    {
      app: "Tax Lien Galaxy", time: "1h ago",
      title: "Redemption deadline · 5 days",
      body: "5602 Palm Ave · file foreclosure by Jun 02 or forfeit lien.",
      color: COLORS.warning, badge: "DEADLINE",
    },
  ];

  return (
    <div style={{
      width: "100%", height: "100%",
      background: "linear-gradient(180deg, #1A2129 0%, #050810 100%)",
      position: "relative", overflow: "hidden",
    }}>
      {/* wallpaper soft glow */}
      <div style={{
        position: "absolute", top: -100, left: -50, right: -50, height: 400,
        background: "radial-gradient(ellipse, rgba(0,91,234,0.35) 0%, transparent 60%)",
      }}/>

      {/* clock */}
      <div style={{
        textAlign: "center", marginTop: 72, color: "#fff",
        textShadow: "0 2px 12px rgba(0,0,0,0.4)",
      }}>
        <div style={{ fontSize: 22, fontWeight: 500, letterSpacing: 0.04 }}>Friday, May 23</div>
        <div style={{ fontSize: 84, fontWeight: 300, lineHeight: 1, letterSpacing: -0.02, marginTop: 4 }}>9:41</div>
      </div>

      {/* notification stack */}
      <div style={{ position: "absolute", bottom: 100, left: 14, right: 14,
                    display: "flex", flexDirection: "column", gap: 6 }}>
        {notifs.map((n, i) => (
          <div key={i} style={{
            background: "rgba(255,255,255,0.85)",
            backdropFilter: "blur(40px) saturate(180%)",
            WebkitBackdropFilter: "blur(40px) saturate(180%)",
            borderRadius: 16, padding: "10px 12px",
            border: "0.5px solid rgba(255,255,255,0.3)",
            display: "flex", gap: 10,
            transform: i > 0 ? `translateY(-${i*2}px) scale(${1 - i*0.015})` : "none",
            opacity: 1 - i * 0.08,
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 8, flexShrink: 0,
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              position: "relative",
            }}>
              {Ico.galaxy}
              {n.urgent && (
                <span style={{
                  position: "absolute", top: -3, right: -3, width: 10, height: 10,
                  borderRadius: "50%", background: COLORS.danger,
                  border: "2px solid rgba(255,255,255,0.85)",
                  boxShadow: `0 0 8px ${COLORS.danger}`,
                }}/>
              )}
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 2 }}>
                <span style={{ fontSize: 11, fontWeight: 600, color: "#3C3C43" }}>{n.app}</span>
                <span style={{
                  fontSize: 9, fontWeight: 700, padding: "1px 5px", borderRadius: 3,
                  background: n.color, color: "#fff", letterSpacing: 0.06,
                }}>{n.badge}</span>
                <span style={{ flex: 1 }}/>
                <span style={{ fontSize: 11, color: "rgba(60,60,67,0.6)" }}>{n.time}</span>
              </div>
              <div style={{ fontSize: 13, fontWeight: 600, color: "#000", lineHeight: 1.25 }}>{n.title}</div>
              <div style={{ fontSize: 12, color: "rgba(60,60,67,0.75)", lineHeight: 1.3, marginTop: 2 }}>{n.body}</div>
            </div>
          </div>
        ))}
      </div>

      {/* Camera + flashlight glass pills (lock screen affordances) */}
      <div style={{ position: "absolute", bottom: 44, left: 24, right: 24,
                    display: "flex", justifyContent: "space-between" }}>
        {[Ico.flag, Ico.bolt].map((ic, i) => (
          <div key={i} style={{
            width: 50, height: 50, borderRadius: "50%",
            background: "rgba(255,255,255,0.18)",
            backdropFilter: "blur(20px)",
            display: "flex", alignItems: "center", justifyContent: "center",
            color: "#fff",
          }}>{ic}</div>
        ))}
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 2. In-app notification inbox
// ──────────────────────────────────────────────────────────────────
function NotifInboxScreen() {
  const groups = [
    { day: "Today", items: [
      { icon: Ico.warn, color: COLORS.danger, time: "9:41",
        title: "Maricopa auction starts in 30 min",
        body: "142 liens · 18% max interest. Bidding opens at 10:11 AM.",
        unread: true, action: "Join" },
      { icon: Ico.trend, color: COLORS.success, time: "8:33",
        title: "Lien redeemed · 1247 Oak St",
        body: "Owner paid $13,094 (you earned $1,994 · 16% APR over 18 months).",
        unread: true, action: "Withdraw" },
      { icon: Ico.ai, color: COLORS.brand, time: "8:18",
        title: "AI: 4 Flipper matches in Duval, FL",
        body: "Avg 22% ROI · 3-day window before public listing.",
        unread: false, action: "Review" },
    ]},
    { day: "This week", items: [
      { icon: Ico.clock, color: COLORS.warning, time: "Wed",
        title: "Redemption deadline · 5 days",
        body: "5602 Palm Ave · file foreclosure by Jun 02.",
        unread: false, action: null },
      { icon: Ico.shield, color: COLORS.purple, time: "Mon",
        title: "Ethics flag: senior-owned",
        body: "1428 Magnolia Blvd · owner is 78. Flagged per your filter.",
        unread: false, action: null },
      { icon: Ico.refresh, color: COLORS.fg2, time: "Mon",
        title: "Stale data refreshed",
        body: "23 properties in Pima County updated with new tax-roll data.",
        unread: false, action: null },
    ]},
  ];

  return (
    <PhoneScreen>
      <TopBar title="Inbox" sub="3 unread"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="settings">{Ico.filter}</IconButton>}
      />
      {/* tabs */}
      <div style={{ padding: "0 20px 12px", display: "flex", gap: 6 }}>
        {["All", "Auctions", "Payouts", "Watchlist", "AI"].map((t, i) => (
          <span key={t} style={{
            padding: "6px 12px", borderRadius: 999,
            background: i === 0 ? "var(--brand-gradient)" : "var(--surface)",
            color: i === 0 ? "#fff" : COLORS.fg1,
            fontSize: 12, fontWeight: 600,
            border: i === 0 ? "0" : "1px solid var(--line)",
          }}>{t}{i === 0 && " · 6"}</span>
        ))}
      </div>

      <div style={{ flex: 1, overflow: "auto", padding: "0 20px 12px" }}>
        {groups.map(g => (
          <div key={g.day}>
            <div style={{
              fontSize: 11, color: COLORS.fg2, textTransform: "uppercase",
              fontWeight: 600, letterSpacing: 0.07, margin: "8px 4px 6px",
            }}>{g.day}</div>
            {g.items.map((n, i) => (
              <div key={i} className="surface-card" style={{
                padding: 12, marginBottom: 6,
                background: n.unread ? "rgba(0,91,234,0.04)" : "var(--surface)",
                position: "relative",
              }}>
                {n.unread && (
                  <span style={{
                    position: "absolute", top: 14, left: 14,
                    width: 7, height: 7, borderRadius: "50%", background: COLORS.brand,
                  }}/>
                )}
                <div style={{ display: "flex", gap: 12, paddingLeft: n.unread ? 14 : 0 }}>
                  <div style={{
                    width: 34, height: 34, borderRadius: 8, flexShrink: 0,
                    background: n.color + "1c", color: n.color,
                    display: "flex", alignItems: "center", justifyContent: "center",
                  }}>{n.icon}</div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
                      <div style={{ fontSize: 13.5, fontWeight: 600, color: COLORS.fg1 }}>{n.title}</div>
                      <div style={{ fontSize: 11, color: COLORS.fg2 }}>{n.time}</div>
                    </div>
                    <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 3, lineHeight: 1.35 }}>{n.body}</div>
                    {n.action && (
                      <button style={{
                        marginTop: 8, padding: "5px 10px", fontSize: 11, fontWeight: 600,
                        background: n.color, color: "#fff",
                        border: 0, borderRadius: 6, cursor: "pointer",
                      }}>{n.action}</button>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        ))}
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 3. macOS-style notification rules / preferences screen
// ──────────────────────────────────────────────────────────────────
function NotifSettingsScreen() {
  const rules = [
    { k: "Auction starts", v: "30 min before", on: true, dot: COLORS.danger },
    { k: "Watchlist payouts", v: "Immediate", on: true, dot: COLORS.success },
    { k: "Redemption deadlines", v: "5d / 1d / 1h", on: true, dot: COLORS.warning },
    { k: "AI new matches", v: "Daily 8 AM", on: true, dot: COLORS.brand },
    { k: "Price changes", v: "± 10% threshold", on: false, dot: COLORS.purple },
    { k: "County data refresh", v: "Weekly digest", on: false, dot: COLORS.cyan },
    { k: "Ethics flag triggered", v: "Per occurrence", on: true, dot: COLORS.purple },
    { k: "Subscription changes", v: "Always", on: true, dot: COLORS.fg1 },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Notifications" sub="Configure all triggers"
        leading={<button className="icon-btn">{Ico.back}</button>}/>
      <div style={{ flex: 1, overflow: "auto", padding: "0 20px 16px" }}>

        {/* mode selector */}
        <div style={{ display: "flex", gap: 6, padding: "8px 0 16px" }}>
          {["All", "Important only", "Quiet"].map((m, i) => (
            <div key={m} style={{
              flex: 1, padding: "10px 8px", borderRadius: 10,
              background: i === 0 ? "var(--brand-gradient)" : "var(--surface)",
              color: i === 0 ? "#fff" : COLORS.fg1,
              boxShadow: i === 0 ? "0 4px 12px rgba(0,91,234,0.25)" : "var(--shadow-card)",
              textAlign: "center", fontSize: 12, fontWeight: 600,
            }}>{m}</div>
          ))}
        </div>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginBottom: 6 }}>Triggers</div>
        <div className="surface-card" style={{ padding: "0 14px" }}>
          {rules.map((r, i) => (
            <div key={r.k} style={{
              display: "flex", alignItems: "center", padding: "12px 0", gap: 10,
              borderBottom: i < rules.length - 1 ? "1px solid var(--line)" : "none",
            }}>
              <div style={{ width: 8, height: 8, borderRadius: "50%", background: r.dot }}/>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, color: COLORS.fg1, fontWeight: 500 }}>{r.k}</div>
                <div style={{ fontSize: 11, color: COLORS.fg2 }}>{r.v}</div>
              </div>
              <FakeSwitch on={r.on}/>
            </div>
          ))}
        </div>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginTop: 16, marginBottom: 6 }}>Quiet hours</div>
        <div className="surface-card" style={{ padding: 14, display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          <div>
            <div style={{ fontSize: 14, color: COLORS.fg1 }}>10:00 PM → 7:30 AM</div>
            <div style={{ fontSize: 11, color: COLORS.fg2 }}>Only "Important only" tier breaks through</div>
          </div>
          <FakeSwitch on={true}/>
        </div>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, marginTop: 16, marginBottom: 6 }}>Channels</div>
        <div className="surface-card" style={{ padding: "0 14px" }}>
          {[
            { k: "Push", v: "iPhone · Watch", on: true },
            { k: "Email", v: "anton@example.com", on: true },
            { k: "SMS", v: "Critical only", on: false },
            { k: "Slack webhook", v: "ELITE only", on: false, locked: true },
          ].map((c, i, arr) => (
            <div key={c.k} style={{
              display: "flex", alignItems: "center", padding: "12px 0",
              borderBottom: i < arr.length - 1 ? "1px solid var(--line)" : "none",
              opacity: c.locked ? 0.5 : 1,
            }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14 }}>{c.k} {c.locked && <Badge tone="purple">PRO+</Badge>}</div>
                <div style={{ fontSize: 11, color: COLORS.fg2 }}>{c.v}</div>
              </div>
              <FakeSwitch on={c.on}/>
            </div>
          ))}
        </div>
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

Object.assign(window, { NotifLockScreen, NotifInboxScreen, NotifSettingsScreen });
