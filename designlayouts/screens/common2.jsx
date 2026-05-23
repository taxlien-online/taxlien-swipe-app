// common2.jsx — tablet/desktop frames, persona data, investment grade,
// extra atoms used by the v2 screens.

// ──────────────────────────────────────────────────────────────────
// Personas (from PersonaPresets)
// ──────────────────────────────────────────────────────────────────
const PERSONAS = [
  { id: "flipper",  name: "Flipper",  full: "The Flipper",
    desc: "High ROI · deed potential",
    long: "Highest yield, willing to take on competition and complexity. Optimizes for `expected_roi` and acquisition probability.",
    color: "#E25A1A", soft: "rgba(226,90,26,0.10)",
    icon: <svg viewBox="0 0 16 16" width="14" height="14" fill="none"><path d="M8 1c-1 3-3 3-3 6 0 2 1 4 3 4s3-2 3-4c0-3-2-3-3-6z" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"/><circle cx="8" cy="7" r="1.5" fill="currentColor"/></svg> },
  { id: "beginner", name: "Beginner", full: "The Beginner",
    desc: "Safe · OTC · low entry",
    long: "First-time investor. Optimizes for low entry price, OTC availability, simple counties.",
    color: "#1FB67A", soft: "rgba(31,182,122,0.10)",
    icon: <svg viewBox="0 0 16 16" width="14" height="14" fill="none"><path d="M1.5 6 8 3l6.5 3-6.5 3L1.5 6z" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"/><path d="M4 7.5v3c0 1 1.5 2 4 2s4-1 4-2v-3" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"/></svg> },
  { id: "landlord", name: "Landlord", full: "The Landlord",
    desc: "Stable · rental potential",
    long: "Buy-and-hold. Optimizes for redemption probability + post-deed rentability (school rating, walkability).",
    color: "#005BEA", soft: "rgba(0,91,234,0.10)",
    icon: <svg viewBox="0 0 16 16" width="14" height="14" fill="none"><path d="M2 7.5 8 2l6 5.5V14H2V7.5zM6 14V9.5h4V14" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"/></svg> },
  { id: "pro",      name: "Pro",      full: "The Pro",
    desc: "Scale · serial late payers",
    long: "Institutional. Optimizes for portfolio scale, serial late-payer patterns, owner concentration.",
    color: "#7B5BEA", soft: "rgba(123,91,234,0.10)",
    icon: <svg viewBox="0 0 16 16" width="14" height="14" fill="none"><rect x="2" y="5" width="12" height="9" rx="1.5" stroke="currentColor" strokeWidth="1.4"/><path d="M6 5V3.5C6 2.7 6.7 2 7.5 2h1c.8 0 1.5.7 1.5 1.5V5" stroke="currentColor" strokeWidth="1.4"/></svg> },
];

// ──────────────────────────────────────────────────────────────────
// Investment grade A–F (SSR site uses this everywhere)
// ──────────────────────────────────────────────────────────────────
const GRADES = {
  A: { color: "#1FB67A", soft: "rgba(31,182,122,0.12)", label: "Strong buy" },
  B: { color: "#005BEA", soft: "rgba(0,91,234,0.10)",   label: "Solid pick" },
  C: { color: "#FFB020", soft: "rgba(255,176,32,0.14)", label: "Moderate"   },
  D: { color: "#E25A1A", soft: "rgba(226,90,26,0.12)",  label: "Caution"    },
  F: { color: "#E5484D", soft: "rgba(229,72,77,0.12)",  label: "Avoid"      },
};
function gradeFor(p) {
  // Derive deterministically from roi, risk, redemp so it matches our data
  const score = p.roi * 200 - p.risk * 0.5 + p.redemp * 30;
  if (score >= 28) return "A";
  if (score >= 18) return "B";
  if (score >= 8)  return "C";
  if (score >= -2) return "D";
  return "F";
}

function GradeBadge({ grade, size = "md" }) {
  const g = GRADES[grade];
  const dim = size === "lg" ? 44 : size === "sm" ? 22 : 32;
  const fontSize = size === "lg" ? 22 : size === "sm" ? 12 : 16;
  return (
    <div style={{
      width: dim, height: dim, borderRadius: 8,
      background: g.color, color: "#fff",
      display: "flex", alignItems: "center", justifyContent: "center",
      fontWeight: 800, fontSize, letterSpacing: -0.01,
      boxShadow: `0 2px 8px ${g.color}55`,
    }}>{grade}</div>
  );
}

// ──────────────────────────────────────────────────────────────────
// Tablet frame — iPad Pro 11" in landscape (1180×820)
// Slimmer bezel, no notch, home indicator bottom-center.
// ──────────────────────────────────────────────────────────────────
function TabletDevice({ children, width = 1180, height = 820, orientation = "landscape", title }) {
  const isPortrait = orientation === "portrait";
  const w = isPortrait ? height : width;
  const h = isPortrait ? width : height;
  return (
    <div style={{
      width: w, height: h, borderRadius: 32, overflow: "hidden",
      background: "#0F1419", padding: 14,
      boxShadow: "0 24px 60px rgba(0,0,0,0.16), 0 0 0 1px rgba(0,0,0,0.10)",
      position: "relative", fontFamily: "var(--font-family)",
    }}>
      <div style={{
        width: "100%", height: "100%", borderRadius: 20, overflow: "hidden",
        background: "var(--bg)", position: "relative",
      }}>
        {children}
        {/* status / home strip */}
        <div style={{
          position: "absolute", left: "50%", bottom: 4,
          transform: "translateX(-50%)",
          width: 96, height: 4, borderRadius: 4,
          background: "rgba(0,0,0,0.20)",
        }}/>
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// Desktop frame — minimal macOS-style chrome (traffic lights only)
// ──────────────────────────────────────────────────────────────────
function DesktopFrame({ children, width = 1440, height = 900, title = "Tax Lien Galaxy" }) {
  return (
    <div style={{
      width, height, borderRadius: 12, overflow: "hidden",
      background: "var(--surface)",
      boxShadow: "0 24px 60px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.10)",
      display: "flex", flexDirection: "column",
      fontFamily: "var(--font-family)",
    }}>
      {/* titlebar */}
      <div style={{
        height: 38, display: "flex", alignItems: "center", padding: "0 16px",
        background: "linear-gradient(180deg, #F7F8FA 0%, #EEF1F4 100%)",
        borderBottom: "1px solid var(--line)",
      }}>
        <div style={{ display: "flex", gap: 8 }}>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#FF5F57", border: "0.5px solid rgba(0,0,0,0.10)" }}/>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#FEBC2E", border: "0.5px solid rgba(0,0,0,0.10)" }}/>
          <span style={{ width: 12, height: 12, borderRadius: "50%", background: "#28C840", border: "0.5px solid rgba(0,0,0,0.10)" }}/>
        </div>
        <div style={{ flex: 1, textAlign: "center", fontSize: 13, color: "var(--fg-1)", fontWeight: 500 }}>{title}</div>
        <div style={{ width: 60 }}/>
      </div>
      <div style={{ flex: 1, position: "relative", background: "var(--bg)", overflow: "hidden" }}>
        {children}
      </div>
    </div>
  );
}

// ──────────────────────────────────────────────────────────────────
// Persona chip (small, used in lists)
// ──────────────────────────────────────────────────────────────────
function PersonaChip({ persona, active, size = "md" }) {
  const p = persona;
  const pad = size === "sm" ? "5px 9px" : "8px 12px";
  return (
    <div style={{
      display: "inline-flex", alignItems: "center", gap: 6, padding: pad,
      borderRadius: 999,
      background: active ? p.color : p.soft,
      color: active ? "#fff" : p.color,
      fontSize: size === "sm" ? 11 : 13, fontWeight: 600,
      border: active ? "0" : "1px solid currentColor",
      boxShadow: active ? `0 4px 12px ${p.color}55` : "none",
    }}>
      <span style={{ display: "inline-flex" }}>{p.icon}</span>
      {p.name}
    </div>
  );
}

// Risk Radar polar chart — 6 axes
function RiskRadarChart({ scores, size = 200 }) {
  // scores: {legal, market, location, condition, financial, competition}
  const axes = ["Legal","Market","Location","Condition","Financial","Competition"];
  const vals = [scores.legal, scores.market, scores.location, scores.condition, scores.financial, scores.competition];
  const overall = Math.round(vals.reduce((s,v)=>s+v,0) / vals.length);
  const c = overall < 30 ? COLORS.success : overall < 60 ? COLORS.warning : COLORS.danger;
  const cx = size/2, cy = size/2, R = size*0.38;
  const pt = (i, r) => {
    const a = -Math.PI/2 + i * (Math.PI*2/6);
    return [cx + Math.cos(a)*r*R/100, cy + Math.sin(a)*r*R/100];
  };
  const poly = vals.map((v, i) => pt(i, v).join(",")).join(" ");
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      {/* rings */}
      {[25,50,75,100].map(r => {
        const pts = Array.from({length:6}, (_,i) => pt(i, r).join(",")).join(" ");
        return <polygon key={r} points={pts} fill="none" stroke="var(--line)" strokeWidth="1"/>;
      })}
      {/* spokes */}
      {Array.from({length:6}, (_,i) => {
        const [x,y] = pt(i, 100);
        return <line key={i} x1={cx} y1={cy} x2={x} y2={y} stroke="var(--line)" strokeWidth="1"/>;
      })}
      {/* data */}
      <polygon points={poly} fill={c} fillOpacity="0.32" stroke={c} strokeWidth="1.8"/>
      {/* axis labels */}
      {axes.map((a, i) => {
        const [x,y] = pt(i, 124);
        return (
          <text key={a} x={x} y={y} textAnchor="middle" dominantBaseline="middle"
                fontSize="10" fill={COLORS.fg2} fontWeight="600">{a}</text>
        );
      })}
      {/* center score */}
      <text x={cx} y={cy-2} textAnchor="middle" fontSize={size*0.13} fontWeight="800" fill={c}>{overall}</text>
      <text x={cx} y={cy+size*0.10} textAnchor="middle" fontSize="9" fill={COLORS.fg2} letterSpacing="0.06em">RISK</text>
    </svg>
  );
}

// Tooltip help icon
function HelpIcon({ size = 12 }) {
  return (
    <span style={{
      display: "inline-flex", alignItems: "center", justifyContent: "center",
      width: size+2, height: size+2, borderRadius: "50%",
      border: "1px solid currentColor", fontSize: size-2,
      fontWeight: 700, opacity: 0.5,
    }}>?</span>
  );
}

// Section header (used inside large dashboards)
function SectionHead({ eyebrow, title, sub, right }) {
  return (
    <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", marginBottom: 12 }}>
      <div>
        {eyebrow && <div style={{ fontSize: 10, color: COLORS.brand, textTransform: "uppercase", fontWeight: 700, letterSpacing: 0.08 }}>{eyebrow}</div>}
        <div style={{ fontSize: 17, fontWeight: 700, color: COLORS.fg1, marginTop: eyebrow ? 2 : 0 }}>{title}</div>
        {sub && <div style={{ fontSize: 12, color: COLORS.fg2, marginTop: 2 }}>{sub}</div>}
      </div>
      {right}
    </div>
  );
}

Object.assign(window, {
  PERSONAS, GRADES, gradeFor, GradeBadge,
  TabletDevice, DesktopFrame,
  PersonaChip, RiskRadarChart, HelpIcon, SectionHead,
});
