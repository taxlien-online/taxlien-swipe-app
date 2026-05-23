// ssr-features.jsx — features lifted from the taxlien-ssr-site:
// PersonaToggle, GradeCard, RiskRadar, SimilarityGalaxy3D, WhatIfSliders,
// SweetSpotExplainer, AttentionHeatmap, OwnerDashboard, Pricing, ApiKey.
// All redesigned to fit the VPN Pro design system.

// ──────────────────────────────────────────────────────────────────
// 1. Persona toggle — pick a strategy and see top picks
// ──────────────────────────────────────────────────────────────────
function PersonaToggleScreen() {
  const active = PERSONAS[0]; // Flipper
  const picks = PROPERTIES.filter(p => p.roi >= 0.18).slice(0, 3);

  return (
    <PhoneScreen>
      <TopBar title="Top picks" sub={`Maricopa, AZ · ${active.full}`}
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="info">{Ico.search}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* persona pills (sticky toggle) */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 6, marginBottom: 14 }}>
          {PERSONAS.map((p, i) => (
            <div key={p.id} style={{
              padding: 10, borderRadius: 10,
              background: i === 0 ? "var(--surface)" : "var(--surface)",
              border: i === 0 ? `2px solid ${p.color}` : "1px solid var(--line)",
              boxShadow: i === 0 ? `0 4px 14px ${p.color}26` : "0 1px 4px rgba(48,63,73,0.04)",
              display: "flex", alignItems: "center", gap: 8,
            }}>
              <div style={{
                width: 28, height: 28, borderRadius: 8,
                background: p.soft, color: p.color,
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>{p.icon}</div>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 600, color: COLORS.fg1 }}>{p.name}</div>
                <div style={{ fontSize: 10, color: COLORS.fg2 }}>{p.desc}</div>
              </div>
            </div>
          ))}
        </div>

        {/* strategy header */}
        <div className="surface-card" style={{
          padding: 14, marginBottom: 10,
          background: `linear-gradient(180deg, ${active.soft} 0%, transparent 100%)`,
          border: `1px solid ${active.color}26`,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <div style={{
              width: 44, height: 44, borderRadius: 12,
              background: active.color, color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              boxShadow: `0 4px 12px ${active.color}55`,
            }}>{active.icon}</div>
            <div>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{active.full} strategy</div>
              <div style={{ fontSize: 11, color: COLORS.fg2, lineHeight: 1.35, marginTop: 2 }}>{active.long}</div>
            </div>
          </div>
        </div>

        {picks.map(p => {
          const grade = gradeFor(p);
          const reasons = [
            grade === "A" && "GRADE A",
            p.roi >= 0.20 && "HIGH ROI",
            p.payback <= 8 && "QUICK PAYBACK",
            p.priorY >= 3 && "DEED LIKELY",
          ].filter(Boolean);

          return (
            <div key={p.id} className="surface-card" style={{ padding: 0, marginBottom: 8, overflow: "hidden" }}>
              <div style={{ display: "flex", gap: 10, padding: 12 }}>
                <div style={{
                  width: 60, height: 60, borderRadius: 8,
                  background: "linear-gradient(135deg, #E8DCC5, #B89F7E)",
                  position: "relative", flexShrink: 0,
                }}>
                  <div style={{ position: "absolute", top: 4, left: 4 }}>
                    <GradeBadge grade={grade} size="sm"/>
                  </div>
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.04, fontWeight: 600 }}>{p.type}</div>
                  <div style={{ fontSize: 14, fontWeight: 700, textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap" }}>{p.address}</div>
                  <div style={{ fontSize: 11, color: COLORS.fg2 }}>{p.city}, {p.state}</div>
                </div>
              </div>
              {/* metrics 4-col */}
              <div style={{
                display: "grid", gridTemplateColumns: "repeat(4, 1fr)",
                padding: "8px 12px", background: "rgba(48,63,73,0.03)",
                borderTop: "1px solid var(--line)", borderBottom: "1px solid var(--line)",
              }}>
                {[
                  { l: "Assessed", v: usd(p.value) },
                  { l: "Tax due",  v: usd(p.tax) },
                  { l: "Rate",     v: `${Math.round(p.intRate*100)}%` },
                  { l: "Market",   v: usd(Math.round(p.value*1.1)) },
                ].map(m => (
                  <div key={m.l}>
                    <div style={{ fontSize: 9, color: COLORS.fg2, textTransform: "uppercase", fontWeight: 500, letterSpacing: 0.04 }}>{m.l}</div>
                    <div style={{ fontSize: 13, fontWeight: 700, color: COLORS.fg1, marginTop: 1 }}>{m.v}</div>
                  </div>
                ))}
              </div>
              {/* predictions */}
              <div style={{
                display: "grid", gridTemplateColumns: "repeat(3, 1fr)",
                padding: "10px 12px",
              }}>
                <div style={{ textAlign: "center" }}>
                  <div style={{ fontSize: 9, color: COLORS.fg2, textTransform: "uppercase", fontWeight: 600 }}>Redemption</div>
                  <div style={{ fontSize: 14, fontWeight: 700, marginTop: 2 }}>{Math.round(p.redemp*100)}%</div>
                </div>
                <div style={{ textAlign: "center", borderLeft: "1px solid var(--line)", borderRight: "1px solid var(--line)" }}>
                  <div style={{ fontSize: 9, color: COLORS.fg2, textTransform: "uppercase", fontWeight: 600 }}>⚠ Risk</div>
                  <div style={{ fontSize: 14, fontWeight: 700, color: colorByRisk(p.risk), marginTop: 2 }}>{p.risk}/100</div>
                </div>
                <div style={{ textAlign: "center" }}>
                  <div style={{ fontSize: 9, color: COLORS.fg2, textTransform: "uppercase", fontWeight: 600 }}>↗ ROI</div>
                  <div style={{ fontSize: 14, fontWeight: 700, color: COLORS.success, marginTop: 2 }}>{pct(p.roi)}</div>
                </div>
              </div>
              {/* reasons */}
              <div style={{ display: "flex", gap: 4, padding: "0 12px 12px", flexWrap: "wrap" }}>
                {reasons.map(r => (
                  <span key={r} style={{
                    padding: "2px 6px", fontSize: 9, fontWeight: 700,
                    background: active.soft, color: active.color,
                    border: `1px solid ${active.color}33`, borderRadius: 4,
                    letterSpacing: 0.06,
                  }}>{r}</span>
                ))}
              </div>
            </div>
          );
        })}
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 2. Risk Radar — 6-axis polar chart on a property detail
// ──────────────────────────────────────────────────────────────────
function RiskRadarScreen() {
  const scores = { legal: 28, market: 42, location: 35, condition: 58, financial: 22, competition: 72 };
  const factors = [
    { name: "Legal",      val: 28, sub: "Title clear · no clouds",                impact: "good" },
    { name: "Market",     val: 42, sub: "Median price flat last 12mo",             impact: "neutral" },
    { name: "Location",   val: 35, sub: "Walk 64 · Schools 7.8",                   impact: "good" },
    { name: "Condition",  val: 58, sub: "Roof age 18yr · last inspection 2024",    impact: "warn" },
    { name: "Financial",  val: 22, sub: "Tax/value 14% · low",                     impact: "good" },
    { name: "Competition",val: 72, sub: "11 bidders in last similar auction",      impact: "bad" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Risk profile" sub="1247 Oak St · 6 factors"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="info">{Ico.search}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        <div className="surface-card" style={{ padding: 16 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "center" }}>
            <RiskRadarChart scores={scores} size={250}/>
          </div>
          <div style={{ textAlign: "center", marginTop: 4 }}>
            <Badge tone="good"><span style={{ width: 6, height: 6, borderRadius: "50%", background: "currentColor" }}/>Below median for Maricopa</Badge>
          </div>
        </div>

        <div style={{ fontSize: 11, color: COLORS.fg2, textTransform: "uppercase", letterSpacing: 0.06, fontWeight: 600, margin: "16px 4px 6px" }}>Factor breakdown</div>
        {factors.map((f, i) => {
          const c = f.impact === "good" ? COLORS.success : f.impact === "warn" ? COLORS.warning : f.impact === "bad" ? COLORS.danger : COLORS.brand;
          return (
            <div key={f.name} className="surface-card" style={{ padding: 12, marginBottom: 6 }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
                <span style={{ fontSize: 13, fontWeight: 600 }}>{f.name}</span>
                <span style={{ fontSize: 14, fontWeight: 700, color: c }}>{f.val}<span style={{ color: COLORS.fg2, fontSize: 10, fontWeight: 500 }}>/100</span></span>
              </div>
              <div style={{ marginTop: 6, height: 4, borderRadius: 2, background: "var(--disabled)", overflow: "hidden" }}>
                <div style={{ height: "100%", width: `${f.val}%`, background: c, borderRadius: 2 }}/>
              </div>
              <div style={{ fontSize: 11, color: COLORS.fg2, marginTop: 6 }}>{f.sub}</div>
            </div>
          );
        })}
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 3. Similarity Galaxy — clustered embeddings (faux-3D)
// ──────────────────────────────────────────────────────────────────
function SimilarityGalaxyScreen() {
  // Generate ~140 points in 4 visible "clusters"
  const clusters = [
    { cx: 32, cy: 30, r: 10, grade: "A", count: 24 },
    { cx: 65, cy: 25, r: 9,  grade: "B", count: 32 },
    { cx: 30, cy: 65, r: 11, grade: "C", count: 41 },
    { cx: 70, cy: 70, r: 7,  grade: "F", count: 16 },
  ];
  const points = [];
  clusters.forEach((cl, ci) => {
    for (let i = 0; i < cl.count; i++) {
      const a = (i / cl.count) * Math.PI * 2 + ci;
      const d = Math.pow((i % 7) / 7, 0.7) * cl.r;
      points.push({
        id: `c${ci}-${i}`,
        x: cl.cx + Math.cos(a) * d + (i%3-1) * 0.6,
        y: cl.cy + Math.sin(a) * d + (i%5-2) * 0.5,
        grade: cl.grade,
        size: 4 + (i%4),
      });
    }
  });
  // a few floating noise points
  for (let i = 0; i < 18; i++) {
    points.push({ id: `n${i}`, x: 10 + (i*43)%80, y: 8 + (i*61)%82, grade: ["A","B","C","F"][i%4], size: 3 });
  }
  // selected one
  const selected = { x: 38, y: 34, grade: "A" };

  return (
    <PhoneScreen dark>
      <div style={{ position: "absolute", inset: "54px 0 92px 0",
                    background: "radial-gradient(ellipse at center, #0E1726 0%, #050810 70%)",
                    overflow: "hidden" }}>
        {/* grid */}
        <svg viewBox="0 0 100 100" preserveAspectRatio="none" style={{ position: "absolute", inset: 0, width: "100%", height: "100%" }}>
          {Array.from({length: 10}).map((_,i) => (
            <line key={"h"+i} x1="0" y1={i*10} x2="100" y2={i*10} stroke="rgba(123,91,234,0.10)" strokeWidth="0.15"/>
          ))}
          {Array.from({length: 10}).map((_,i) => (
            <line key={"v"+i} x1={i*10} y1="0" x2={i*10} y2="100" stroke="rgba(123,91,234,0.10)" strokeWidth="0.15"/>
          ))}
        </svg>

        {/* points */}
        {points.map(p => (
          <div key={p.id} style={{
            position: "absolute", left: `${p.x}%`, top: `${p.y}%`,
            transform: "translate(-50%,-50%)",
            width: p.size, height: p.size, borderRadius: "50%",
            background: GRADES[p.grade].color,
            boxShadow: `0 0 ${p.size*2}px ${GRADES[p.grade].color}`,
            opacity: 0.75,
          }}/>
        ))}

        {/* selected with crosshair */}
        <div style={{
          position: "absolute", left: `${selected.x}%`, top: `${selected.y}%`,
          transform: "translate(-50%,-50%)",
          width: 18, height: 18, borderRadius: "50%",
          background: "transparent", border: "1.5px solid #fff",
          boxShadow: "0 0 24px #00C6FB",
        }}/>
        <svg style={{ position: "absolute", left: `${selected.x}%`, top: `${selected.y}%`,
                      transform: "translate(-50%,-50%)", pointerEvents: "none" }}
             width="80" height="80" viewBox="0 0 80 80">
          <line x1="40" y1="2" x2="40" y2="22" stroke="#fff" strokeWidth="0.8"/>
          <line x1="40" y1="58" x2="40" y2="78" stroke="#fff" strokeWidth="0.8"/>
          <line x1="2" y1="40" x2="22" y2="40" stroke="#fff" strokeWidth="0.8"/>
          <line x1="58" y1="40" x2="78" y2="40" stroke="#fff" strokeWidth="0.8"/>
        </svg>

        {/* cluster labels */}
        {clusters.map((c, i) => (
          <div key={i} style={{
            position: "absolute", left: `${c.cx}%`, top: `${c.cy - c.r - 1}%`,
            transform: "translate(-50%, -100%)", textAlign: "center",
          }}>
            <div style={{
              padding: "3px 8px", borderRadius: 999,
              background: GRADES[c.grade].color + "33", color: "#fff",
              fontSize: 10, fontWeight: 700, letterSpacing: 0.05,
              border: `1px solid ${GRADES[c.grade].color}`,
            }}>Grade {c.grade} · {c.count}</div>
          </div>
        ))}
      </div>

      <TopBar title="Similarity Galaxy"
        sub={<span style={{ color: "rgba(255,255,255,0.6)" }}>3D latent space · 140 properties</span>}
        leading={<button className="icon-btn" style={{ background: "rgba(255,255,255,0.08)", color: "#fff" }}>{Ico.back}</button>}
        trailing={
          <div style={{ display: "inline-flex", gap: 6, alignItems: "center", color: "#fff", fontSize: 10 }}>
            <span style={{ width: 6, height: 6, borderRadius: "50%", background: COLORS.cyan, animation: "blink 1s infinite" }}/>
            <span style={{ fontWeight: 700, letterSpacing: 0.05 }}>DL-v2.4</span>
          </div>
        }
      />

      <div style={{ position: "absolute", left: 14, right: 14, bottom: 102, zIndex: 5 }}>
        <div style={{
          background: "rgba(15,23,42,0.9)",
          backdropFilter: "blur(20px)",
          border: "1px solid rgba(123,91,234,0.3)",
          borderRadius: 14, padding: 12,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, color: "#fff", marginBottom: 8 }}>
            <div style={{
              width: 26, height: 26, borderRadius: "50%",
              background: "var(--brand-gradient)", color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.galaxy}</div>
            <div>
              <div style={{ fontSize: 13, fontWeight: 700 }}>1247 Oak Street</div>
              <div style={{ fontSize: 10, color: "rgba(255,255,255,0.55)" }}>cluster: Grade A · 18 nearest neighbors</div>
            </div>
          </div>
          <div style={{ display: "flex", gap: 6, flexWrap: "wrap" }}>
            <Badge tone="good">22% avg ROI</Badge>
            <Badge tone="info">Maricopa-heavy</Badge>
            <Badge tone="purple">3yr+ delinquent</Badge>
          </div>
        </div>
      </div>

      <BottomNav active="galaxy"/>
      <style>{`@keyframes blink { 50% { opacity: 0.2 } }`}</style>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 4. What-If Simulator — sliders → grade projection
// ──────────────────────────────────────────────────────────────────
function WhatIfScreen() {
  // Slider positions (0..1)
  const vals = { value: 0.5, tax: 0.3, risk: 0.32, redemp: 0.74 };
  return (
    <PhoneScreen>
      <TopBar title="What-If" sub="Adjust to project grade"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="reset">{Ico.refresh}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* Hero projection */}
        <div className="surface-card" style={{
          padding: 18, marginBottom: 14,
          background: "linear-gradient(135deg, #1E1F47 0%, #0F1419 100%)",
          color: "#fff", textAlign: "center",
        }}>
          <div style={{ fontSize: 10, color: "rgba(255,255,255,0.55)", letterSpacing: 0.10, fontWeight: 700, textTransform: "uppercase", marginBottom: 4 }}>
            Projected grade
          </div>
          <div style={{ fontSize: 84, fontWeight: 900, lineHeight: 1, color: "#1FB67A",
                        textShadow: "0 0 30px rgba(31,182,122,0.5)" }}>B</div>
          <div style={{
            display: "flex", gap: 10, justifyContent: "center",
            paddingTop: 14, marginTop: 14, borderTop: "1px solid rgba(255,255,255,0.1)",
          }}>
            <div>
              <div style={{ fontSize: 9, color: "rgba(255,255,255,0.5)", textTransform: "uppercase", fontWeight: 700, letterSpacing: 0.06 }}>Est. ROI</div>
              <div style={{ fontSize: 19, fontWeight: 700 }}>14.3%</div>
            </div>
            <div style={{ width: 1, background: "rgba(255,255,255,0.1)" }}/>
            <div>
              <div style={{ fontSize: 9, color: "rgba(255,255,255,0.5)", textTransform: "uppercase", fontWeight: 700, letterSpacing: 0.06 }}>LTV</div>
              <div style={{ fontSize: 19, fontWeight: 700 }}>11.2%</div>
            </div>
            <div style={{ width: 1, background: "rgba(255,255,255,0.1)" }}/>
            <div>
              <div style={{ fontSize: 9, color: "rgba(255,255,255,0.5)", textTransform: "uppercase", fontWeight: 700, letterSpacing: 0.06 }}>Confidence</div>
              <div style={{ fontSize: 19, fontWeight: 700 }}>88%</div>
            </div>
          </div>
          <div style={{ fontSize: 9, color: "rgba(255,255,255,0.4)", marginTop: 12, fontStyle: "italic" }}>
            Simulated via local ensemble model · DL-v2.4
          </div>
        </div>

        {/* Sliders */}
        <Slider label="Assessed value"  value="$89,000"  pos={vals.value}  range="$40k → $180k"/>
        <Slider label="Tax amount"      value="$12,450"  pos={vals.tax}    range="$1k → $60k"/>
        <Slider label="Owner risk"      value="32 / 100" pos={vals.risk}   range="Low → High" tone={colorByRisk(32)}/>
        <Slider label="Redemption prob." value="74%"     pos={vals.redemp} range="0% → 100%" tone={COLORS.brand}/>

        <div className="surface-card" style={{
          padding: 12, marginTop: 8, display: "flex", alignItems: "center", gap: 10,
          background: "rgba(0,91,234,0.04)", border: `1px solid ${COLORS.brand}22`,
        }}>
          <div style={{ width: 26, height: 26, borderRadius: "50%", background: "var(--brand-gradient)", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center" }}>{Ico.ai}</div>
          <div style={{ flex: 1, fontSize: 11, color: COLORS.fg1, lineHeight: 1.35 }}>
            Lowering tax by 30% raises grade to <b>A</b>. Try the Negotiate Offer flow.
          </div>
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function Slider({ label, value, pos, range, tone }) {
  const c = tone || COLORS.brand;
  return (
    <div style={{ padding: "12px 0" }}>
      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
        <span style={{ fontSize: 13, fontWeight: 500, color: COLORS.fg1 }}>{label}</span>
        <span style={{ fontSize: 13, fontFamily: "monospace", color: c, fontWeight: 700 }}>{value}</span>
      </div>
      <div style={{ position: "relative", height: 18 }}>
        <div style={{ position: "absolute", top: 7, left: 0, right: 0, height: 4, borderRadius: 2, background: "var(--disabled)" }}/>
        <div style={{ position: "absolute", top: 7, left: 0, width: `${pos*100}%`, height: 4, borderRadius: 2, background: c }}/>
        <div style={{
          position: "absolute", top: 0, left: `${pos*100}%`, transform: "translateX(-50%)",
          width: 18, height: 18, borderRadius: "50%", background: "#fff",
          border: `2px solid ${c}`, boxShadow: `0 2px 6px ${c}44`,
        }}/>
      </div>
      <div style={{ display: "flex", justifyContent: "space-between", fontSize: 10, color: COLORS.fg2, marginTop: 4 }}>
        <span>{range.split("→")[0]}</span>
        <span>{range.split("→")[1]}</span>
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 5. Sweet Spot Explainer
// ──────────────────────────────────────────────────────────────────
function SweetSpotScreen() {
  const factors = [
    { title: "Serial late payers",  desc: "Owners who historically pay just before foreclosure — high interest, low deed risk.",
      icon: Ico.bolt,  color: COLORS.warning, tone: "warn" },
    { title: "Equity cushion",      desc: "High assessed value, low tax debt. If owner doesn't redeem, your deed exit is safe.",
      icon: Ico.shield, color: COLORS.success, tone: "good" },
    { title: "Market velocity",     desc: "Located in zip codes where median price is rising > 6% YoY.",
      icon: Ico.trend, color: COLORS.brand,   tone: "info" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="The AI Sweet Spot" sub="Why these properties stand out"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* Hero target diagram */}
        <div className="surface-card" style={{ padding: 20, marginBottom: 14, textAlign: "center", position: "relative", overflow: "hidden" }}>
          <div style={{ position: "absolute", inset: 0,
                        background: "radial-gradient(circle at center, rgba(229,72,77,0.06) 0%, transparent 70%)" }}/>
          <svg viewBox="0 0 220 160" width="100%" height="160">
            {/* concentric target */}
            <circle cx="110" cy="80" r="68" fill="#fff" stroke={COLORS.fg2} strokeWidth="0.5" strokeDasharray="2 3"/>
            <circle cx="110" cy="80" r="48" fill="#fff" stroke={COLORS.warning} strokeWidth="0.5"/>
            <circle cx="110" cy="80" r="28" fill="#fff" stroke={COLORS.success} strokeWidth="0.5"/>
            <circle cx="110" cy="80" r="12" fill={COLORS.danger} opacity="0.85"/>
            <text x="110" y="84" textAnchor="middle" fontSize="9" fontWeight="700" fill="#fff" letterSpacing="0.05em">SWEET</text>
            {/* 3 zones */}
            <text x="58"  y="40"  textAnchor="middle" fontSize="9" fill={COLORS.warning} fontWeight="700">SERIAL</text>
            <text x="162" y="40"  textAnchor="middle" fontSize="9" fill={COLORS.success} fontWeight="700">EQUITY</text>
            <text x="110" y="145" textAnchor="middle" fontSize="9" fill={COLORS.brand}   fontWeight="700">VELOCITY</text>
          </svg>
          <div style={{ fontSize: 20, fontWeight: 700, color: COLORS.fg1, marginTop: 6, letterSpacing: -0.01 }}>
            Intersection of yield × safety × growth
          </div>
          <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 6, lineHeight: 1.4 }}>
            Our deep learning models identify properties hitting all three. Below 3% of liens qualify in any county.
          </div>
        </div>

        {factors.map(f => (
          <div key={f.title} className="surface-card" style={{ padding: 14, marginBottom: 8, display: "flex", gap: 12, alignItems: "flex-start" }}>
            <div style={{
              width: 44, height: 44, borderRadius: 12,
              background: f.color + "1c", color: f.color,
              display: "flex", alignItems: "center", justifyContent: "center",
              flexShrink: 0,
            }}>{f.icon}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 700 }}>{f.title}</div>
              <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 4, lineHeight: 1.4 }}>{f.desc}</div>
            </div>
          </div>
        ))}

        {/* result */}
        <div style={{
          padding: 16, marginTop: 6, borderRadius: 14,
          border: "2px dashed var(--line)",
          textAlign: "center",
        }}>
          <div style={{ fontSize: 10, fontWeight: 700, color: COLORS.fg2, letterSpacing: 0.08, textTransform: "uppercase", marginBottom: 6 }}>Result</div>
          <div style={{ fontSize: 17, fontWeight: 800, letterSpacing: -0.01, color: COLORS.fg1 }}>
            High-yield, low-competition clusters
          </div>
          <div style={{ marginTop: 10 }}>
            <Badge tone="good">23 found in your jurisdictions</Badge>
          </div>
        </div>
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 6. Attention Heatmap — neural feature importance
// ──────────────────────────────────────────────────────────────────
function AttentionMapScreen() {
  const fields = [
    { f: "Prior years owed",        s: 0.88, impact: "negative" },
    { f: "Owner serial payer",      s: 0.74, impact: "positive" },
    { f: "Tax / value ratio",       s: 0.62, impact: "positive" },
    { f: "Zillow vs assessed",      s: 0.51, impact: "positive" },
    { f: "Flood zone",              s: 0.38, impact: "negative" },
    { f: "School rating",           s: 0.32, impact: "positive" },
    { f: "County competition",      s: 0.28, impact: "negative" },
    { f: "Year built",              s: 0.18, impact: "neutral" },
    { f: "Walkability",             s: 0.12, impact: "neutral" },
  ];

  return (
    <PhoneScreen>
      <TopBar title="Attention map" sub="Why grade B"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        <div className="surface-card" style={{ padding: 14 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 4 }}>
            <div style={{ fontSize: 15, fontWeight: 700, display: "flex", alignItems: "center", gap: 6 }}>
              Neural attention <HelpIcon/>
            </div>
            <Badge tone="purple">DL-v2.4</Badge>
          </div>
          <div style={{ fontSize: 11, color: COLORS.fg2, marginBottom: 14 }}>
            Feature importance via integrated gradients. Top fields drove the prediction most.
          </div>

          {fields.map(item => {
            const c = item.impact === "positive" ? COLORS.success
                   : item.impact === "negative" ? COLORS.danger
                                                : COLORS.brand;
            return (
              <div key={item.f} style={{ marginBottom: 11, position: "relative" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 4 }}>
                  <span style={{ fontSize: 13, color: COLORS.fg1, fontWeight: 500 }}>{item.f}</span>
                  <span style={{ fontSize: 10, color: COLORS.fg2, fontFamily: "monospace" }}>{(item.s*100).toFixed(1)}% weight</span>
                </div>
                <div style={{ height: 10, borderRadius: 5, background: "var(--bg)", overflow: "hidden", position: "relative" }}>
                  <div style={{ height: "100%", width: `${item.s*100}%`, background: c, borderRadius: 5,
                                boxShadow: item.s > 0.6 ? `0 0 12px ${c}55` : "none" }}/>
                </div>
                {item.s > 0.6 && (
                  <span style={{
                    position: "absolute", top: -2, right: -2, fontSize: 8,
                    padding: "2px 5px", borderRadius: 3,
                    background: "#fff", color: c, fontWeight: 700,
                    border: `1px solid ${c}55`, letterSpacing: 0.05,
                  }}>CRITICAL</span>
                )}
              </div>
            );
          })}
        </div>

        <div className="surface-card" style={{ padding: 12, marginTop: 8,
              background: "rgba(123,91,234,0.04)", border: `1px solid ${COLORS.purple}22`,
              display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ width: 26, height: 26, borderRadius: "50%", background: COLORS.purple + "1c", color: COLORS.purple, display: "flex", alignItems: "center", justifyContent: "center" }}>{Ico.ai}</div>
          <div style={{ flex: 1, fontSize: 11, color: COLORS.fg1, lineHeight: 1.4 }}>
            The model focused 88% on <b>prior years owed</b> — clear distress signal driving the deed-likelihood up.
          </div>
        </div>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 7. Owner Dashboard — owner-level portfolio analytics
// ──────────────────────────────────────────────────────────────────
function OwnerDashScreen() {
  return (
    <PhoneScreen>
      <TopBar title="Owner" sub="Portfolio profile · PRO blur"
        leading={<button className="icon-btn">{Ico.back}</button>}
        trailing={<IconButton label="more">{Ico.more}</IconButton>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* Owner header */}
        <div className="surface-card" style={{ padding: 14, marginBottom: 8 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <div style={{
              width: 50, height: 50, borderRadius: "50%",
              background: COLORS.purple, color: "#fff",
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 19, fontWeight: 700,
            }}>JK</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ filter: "blur(5px)", fontSize: 17, fontWeight: 700, color: COLORS.fg2 }}>██████ ██████</span>
                <span style={{
                  padding: "2px 7px", borderRadius: 4, background: COLORS.brand,
                  color: "#fff", fontSize: 9, fontWeight: 700, letterSpacing: 0.06,
                  display: "inline-flex", alignItems: "center", gap: 3,
                }}>{Ico.shield} PRO</span>
              </div>
              <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2 }}>Individual Investor · Portfolio Analysis</div>
            </div>
          </div>
          <div style={{
            marginTop: 12, padding: 10, borderRadius: 10,
            background: "rgba(255,176,32,0.10)",
            border: `1px solid ${COLORS.warning}44`,
            display: "flex", alignItems: "center", gap: 10,
          }}>
            <div style={{ width: 30, height: 30, borderRadius: 8, background: COLORS.warning, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center" }}>{Ico.warn}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 12, fontWeight: 700, color: "#80501A" }}>Serial Payer Score</div>
              <div style={{ fontSize: 11, color: "#A86E1C" }}>78/100 · pays just before foreclosure</div>
            </div>
          </div>
        </div>

        {/* portfolio stats */}
        <SectionHead eyebrow="Portfolio" title="Owner stats" sub="14 properties tracked"/>
        <div className="surface-card" style={{ padding: 12 }}>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <Stat dt="Active liens"        dd="9"     accent={COLORS.brand}/>
            <Stat dt="Foreclosed"          dd="2"     accent={COLORS.danger}/>
            <Stat dt="Delinquency rate"    dd="34%"   accent={COLORS.danger} blurred/>
            <Stat dt="Data trust"          dd="High"  accent={COLORS.success} blurred/>
            <Stat dt="Avg redemption time" dd="11mo"  accent={COLORS.brand}/>
            <Stat dt="Total tax debt"      dd="$248k" accent={COLORS.fg1}/>
          </div>
        </div>

        <SectionHead eyebrow="Geography" title="Spread" right={<Badge tone="info">3 states · 5 counties</Badge>}/>
        <div className="surface-card" style={{ padding: 12 }}>
          <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600, marginBottom: 6 }}>States</div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {["AZ","FL","TX"].map(s => (
              <span key={s} style={{
                padding: "4px 10px", fontSize: 11, fontWeight: 700,
                background: "rgba(0,91,234,0.08)", color: COLORS.brand,
                border: `1px solid ${COLORS.brand}22`, borderRadius: 4,
                letterSpacing: 0.04,
              }}>{s}</span>
            ))}
          </div>
          <hr className="divider"/>
          <div style={{ fontSize: 11, color: COLORS.fg2, fontWeight: 600, marginBottom: 6 }}>Counties</div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {["Maricopa","Pima","Duval","Orange","Harris"].map(c => (
              <span key={c} style={{
                padding: "4px 10px", fontSize: 11,
                background: "rgba(48,63,73,0.06)", color: COLORS.fg1,
                border: "1px solid var(--line)", borderRadius: 4,
                fontWeight: 500,
              }}>{c}</span>
            ))}
          </div>
        </div>

        <button className="cta" style={{ width: "100%", marginTop: 14, padding: "13px", fontSize: 14 }}>
          {Ico.shield} Unlock owner contact · PRO $49/mo
        </button>
      </div>
      <BottomNav active="list"/>
    </PhoneScreen>
  );
}

function Stat({ dt, dd, accent, blurred }) {
  return (
    <div>
      <dt style={{ fontSize: 11, color: COLORS.fg2 }}>{dt}</dt>
      <dd style={{ fontSize: 18, fontWeight: 700, color: accent || COLORS.fg1, margin: 0, marginTop: 2,
                   filter: blurred ? "blur(4px)" : "none", userSelect: blurred ? "none" : "auto" }}>
        {dd}
      </dd>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// 8. Pricing — 4 tiers
// ──────────────────────────────────────────────────────────────────
function PricingScreen() {
  const plans = [
    { name: "FREE",  price: "$0",  period: "",     desc: "Explore the market",
      popular: false, cta: "Get started",
      features: [
        { f: "Basic property data", on: true },
        { f: "Search & filters", on: true },
        { f: "Redemption probability", on: true },
        { f: "Risk & ROI scores", on: false },
        { f: "Owner contact info", on: false },
        { f: "Unlimited watchlist", on: false },
      ]},
    { name: "BASIC", price: "$19", period: "/mo",  desc: "AI-powered insights",
      popular: false, cta: "Upgrade",
      features: [
        { f: "Full ML predictions", on: true },
        { f: "Sweet Spot analysis", on: true },
        { f: "Detailed tax history", on: true },
        { f: "Risk & ROI scores", on: true },
        { f: "Owner contact info", on: false },
        { f: "50 saved properties", on: true },
      ]},
    { name: "PRO",   price: "$49", period: "/mo",  desc: "Advanced tools",
      popular: true, cta: "Go Pro",
      features: [
        { f: "All BASIC features", on: true },
        { f: "Full owner details", on: true },
        { f: "Mailing addresses", on: true },
        { f: "Real-time auction alerts", on: true },
        { f: "Priority data updates", on: true },
        { f: "Unlimited watchlist", on: true },
      ]},
    { name: "ELITE", price: "$99", period: "/mo",  desc: "Enterprise + API",
      popular: false, cta: "Contact sales",
      features: [
        { f: "All PRO features", on: true },
        { f: "API access (/api/v1)", on: true },
        { f: "Advanced analytics", on: true },
        { f: "Bulk data export", on: true },
        { f: "Custom reports", on: true },
        { f: "Priority support", on: true },
      ]},
  ];

  return (
    <PhoneScreen>
      <TopBar title="Pricing" sub="Choose the right plan"
        leading={<button className="icon-btn">{Ico.close}</button>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        {/* Toggle billing */}
        <div style={{ display: "flex", gap: 4, padding: 4, background: "var(--bg)",
                      border: "1px solid var(--line)", borderRadius: 10, marginBottom: 14 }}>
          <div style={{ flex: 1, padding: "8px 12px", borderRadius: 8, background: "var(--surface)",
                        boxShadow: "var(--shadow-card)", textAlign: "center", fontSize: 12, fontWeight: 600 }}>
            Monthly
          </div>
          <div style={{ flex: 1, padding: "8px 12px", textAlign: "center", fontSize: 12, color: COLORS.fg2, fontWeight: 500 }}>
            Yearly · save 20%
          </div>
        </div>

        {plans.map((p, i) => (
          <div key={p.name} className="surface-card" style={{
            padding: 14, marginBottom: 10, position: "relative",
            border: p.popular ? `2px solid ${COLORS.brand}` : "0",
            boxShadow: p.popular ? "0 8px 22px rgba(0,91,234,0.18)" : "var(--shadow-card)",
          }}>
            {p.popular && (
              <div style={{
                position: "absolute", top: -10, right: 14,
                padding: "3px 10px", borderRadius: 999,
                background: "var(--brand-gradient)", color: "#fff",
                fontSize: 9, fontWeight: 700, letterSpacing: 0.08, textTransform: "uppercase",
              }}>Most popular</div>
            )}
            <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between" }}>
              <div>
                <div style={{ fontSize: 11, color: p.popular ? COLORS.brand : COLORS.fg2,
                              textTransform: "uppercase", letterSpacing: 0.08, fontWeight: 700 }}>{p.name}</div>
                <div style={{ display: "flex", alignItems: "baseline", gap: 3, marginTop: 4 }}>
                  <span style={{ fontSize: 28, fontWeight: 800, letterSpacing: -0.01 }}>{p.price}</span>
                  <span style={{ fontSize: 14, color: COLORS.fg2, fontWeight: 600 }}>{p.period}</span>
                </div>
                <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2 }}>{p.desc}</div>
              </div>
              {i === 1 && <Badge tone="good">Your plan</Badge>}
            </div>
            <ul style={{ listStyle: "none", padding: 0, margin: "12px 0", display: "flex", flexDirection: "column", gap: 6 }}>
              {p.features.map(f => (
                <li key={f.f} style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 12 }}>
                  <span style={{
                    width: 16, height: 16, borderRadius: "50%",
                    background: f.on ? COLORS.success+"22" : "rgba(48,63,73,0.05)",
                    color: f.on ? COLORS.success : COLORS.fg2,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 10, fontWeight: 700,
                  }}>{f.on ? "✓" : "×"}</span>
                  <span style={{ color: f.on ? COLORS.fg1 : COLORS.fg2 }}>{f.f}</span>
                </li>
              ))}
            </ul>
            <button className={p.popular ? "cta" : "cta cta--ghost"}
              style={{ width: "100%", padding: "11px", fontSize: 13 }}>
              {p.cta}
            </button>
          </div>
        ))}

        <div style={{ fontSize: 11, color: COLORS.fg2, textAlign: "center", marginTop: 8 }}>
          All plans · cancel anytime · 14-day refund
        </div>
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

// ──────────────────────────────────────────────────────────────────
// 9. API Key manager — ELITE only
// ──────────────────────────────────────────────────────────────────
function ApiKeyScreen() {
  return (
    <PhoneScreen>
      <TopBar title="API access" sub="ELITE · Institutional"
        leading={<button className="icon-btn">{Ico.back}</button>}
      />
      <div style={{ flex: 1, overflow: "auto", padding: "0 16px 12px" }}>
        <div className="surface-card" style={{ padding: 16,
              background: "linear-gradient(180deg, #1E1F47 0%, #0F1419 100%)",
              color: "#fff", marginBottom: 14 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 14 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 10,
              background: "rgba(0,198,251,0.18)", color: COLORS.cyan,
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{Ico.shield}</div>
            <div>
              <div style={{ fontSize: 14, fontWeight: 700 }}>Institutional API</div>
              <div style={{ fontSize: 11, color: "rgba(255,255,255,0.6)" }}>Authenticate to /api/v1/*</div>
            </div>
          </div>
          <div style={{
            padding: "10px 12px", borderRadius: 8,
            background: "rgba(255,255,255,0.06)",
            fontFamily: "monospace", fontSize: 11, color: "rgba(255,255,255,0.9)",
            letterSpacing: 0.05, display: "flex", alignItems: "center", gap: 8,
            wordBreak: "break-all",
          }}>
            <span style={{ flex: 1 }}>tlk_live_•••••••••••••8c4a</span>
            <span style={{
              display: "inline-flex", alignItems: "center", gap: 4,
              padding: "3px 7px", borderRadius: 4,
              background: "rgba(31,182,122,0.18)", color: COLORS.success,
              fontSize: 10, fontWeight: 700,
            }}>{Ico.link} Copy</span>
          </div>
          <div style={{ fontSize: 10, color: "rgba(255,255,255,0.45)", marginTop: 8 }}>
            Last rotated: 4 days ago · 23,420 requests this month
          </div>
        </div>

        <SectionHead eyebrow="Quotas" title="This month"/>
        <div style={{ display: "flex", gap: 8 }}>
          <StatTile label="Requests" value="23.4k" sub="/ 100k" accent={COLORS.brand}/>
          <StatTile label="Errors" value="0.2%" accent={COLORS.success}/>
          <StatTile label="Latency" value="84ms" sub="p95"/>
        </div>

        <SectionHead eyebrow="Endpoints" title="Most used"/>
        <div className="surface-card" style={{ padding: 0, overflow: "hidden" }}>
          {[
            { m: "GET", path: "/v1/properties",      count: "12,431" },
            { m: "GET", path: "/v1/properties/:id",  count: "6,287" },
            { m: "POST",path: "/v1/dl/predict",      count: "3,104" },
            { m: "GET", path: "/v1/owners/:id",      count: "1,422" },
            { m: "GET", path: "/v1/dl/embeddings",   count: "176" },
          ].map((r, i, arr) => (
            <div key={r.path} style={{
              display: "flex", alignItems: "center", gap: 10, padding: "12px 14px",
              borderBottom: i < arr.length - 1 ? "1px solid var(--line)" : "none",
            }}>
              <span style={{
                padding: "2px 6px", borderRadius: 4, fontSize: 9, fontWeight: 700,
                background: r.m === "GET" ? COLORS.success+"22" : COLORS.warning+"22",
                color: r.m === "GET" ? COLORS.success : COLORS.warning,
                fontFamily: "monospace", letterSpacing: 0.04,
              }}>{r.m}</span>
              <span style={{ flex: 1, fontFamily: "monospace", fontSize: 12, color: COLORS.fg1 }}>{r.path}</span>
              <span style={{ fontSize: 11, color: COLORS.fg2, fontVariantNumeric: "tabular-nums" }}>{r.count}</span>
            </div>
          ))}
        </div>

        <div style={{ display: "flex", gap: 8, marginTop: 14 }}>
          <button className="cta cta--ghost" style={{ flex: 1, fontSize: 13, padding: "11px" }}>
            {Ico.refresh} Rotate key
          </button>
          <button className="cta" style={{ flex: 1, fontSize: 13, padding: "11px" }}>
            Read docs
          </button>
        </div>
        <div style={{ fontSize: 10, color: COLORS.fg2, textAlign: "center", marginTop: 10 }}>
          Rotating invalidates the previous key immediately.
        </div>
      </div>
      <BottomNav active="profile"/>
    </PhoneScreen>
  );
}

Object.assign(window, {
  PersonaToggleScreen, RiskRadarScreen, SimilarityGalaxyScreen,
  WhatIfScreen, SweetSpotScreen, AttentionMapScreen,
  OwnerDashScreen, PricingScreen, ApiKeyScreen,
});
