# Washington High School Graduation Tracker (Starter Plan)

This repository contains a practical starter blueprint for building an app that helps Washington high school students stay on track for graduation.

## Goal

Build a counselor/student-facing system that continuously answers:

1. **What has this student completed?**
2. **What is still missing for Washington graduation?**
3. **What should they take next term/year to stay on track?**
4. **Are there any risk alerts (e.g., pathway not met, credit deficits, missing HSBP updates)?**

---

## Washington Graduation Requirements (baseline snapshot)

> Snapshot date for this repo: **2026-04-23**. District policy can add local requirements; always verify against current OSPI/SBE guidance.

A student generally needs to satisfy **all three** state-level components:

1. **Minimum 24 credits** in required subject areas.
2. **High School and Beyond Plan (HSBP)** completion.
3. **At least one Graduation Pathway Option**.

This app should model state requirements as configurable policy data, not hardcoded logic.

---

## Core product features (MVP)

- Student profile + expected graduation cohort year.
- Transcript ingestion (manual entry first, SIS import later).
- Requirement engine:
  - Subject-area credit audit.
  - Personalized Pathway Requirement (PPR) tracking.
  - HSBP milestones checklist by grade band.
  - Graduation Pathway status.
- On-track dashboard:
  - "On Track", "At Risk", "Off Track" states.
  - Deficiency list with actionable next steps.
- Planning module:
  - 4-year course plan.
  - Next-term recommendations based on missing requirements.
- Counselor tools:
  - Caseload risk view.
  - Bulk reminders.
  - Exportable audit report.

---

## Suggested architecture

- **Frontend:** React/Next.js (student, parent, counselor portals).
- **Backend API:** Node.js (NestJS/Express) or Python (FastAPI).
- **Database:** PostgreSQL.
- **Rules layer:** JSON/YAML policy + deterministic evaluator service.
- **Auth:** District SSO (OIDC/SAML) where available.
- **Auditability:** Save evaluation inputs/outputs per run for compliance reviews.

---

## Data model (high level)

- `students`
- `courses`
- `course_attempts`
- `graduation_rulesets`
- `ruleset_subject_requirements`
- `ruleset_pathways`
- `student_hsbp_events`
- `student_pathway_evidence`
- `graduation_audits`

See `docs/schema.sql` for a starter schema.

---

## Rule modeling notes

Washington requirements and district policies evolve. Keep rules versioned:

- Ruleset key pattern: `wa-state-{cohort_year}-v{n}`
- Store effective dates and source URL metadata.
- Evaluate students only against the ruleset mapped to their cohort (plus district overrides).

Example starter ruleset is in:

- `config/washington_graduation_rules_2026.json`

---

## Risk scoring example

Simple heuristic for counselor triage:

- +3 risk: Missing any core credit area by projected timeline.
- +3 risk: No valid graduation pathway evidence by end of junior year.
- +2 risk: HSBP milestones incomplete by grade-level checkpoints.
- +2 risk: Failed required course more than once.
- +1 risk: Chronic attendance concern flag.

Risk bands:

- `0-2` = On Track
- `3-5` = At Risk
- `6+` = Off Track

---

## Build plan (first 6 weeks)

1. **Week 1:** Finalize rules data structure and district-specific deltas.
2. **Week 2:** Implement transcript + credit audit engine.
3. **Week 3:** Implement HSBP + pathway tracking.
4. **Week 4:** Build student and counselor dashboards.
5. **Week 5:** Add alerts, exports, and audit history.
6. **Week 6:** Pilot with one counseling team and validate against real transcripts.

---

## Compliance and safety notes

- FERPA: protect student educational records.
- Principle of least privilege by role.
- Maintain immutable audit logs of requirement evaluations.
- Avoid automated decisions without human review for high-stakes outcomes.

---

## Next step

If you want, the next iteration can add:

1. A working API skeleton (FastAPI or NestJS).
2. A seed script for Washington sample requirements.
3. A basic dashboard with on-track/off-track cards.

