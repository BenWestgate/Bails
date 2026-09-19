# Assessment status

This directory preserves the Concept NACK hardening assessment as it was
developed on 2026-09-18. Its evidence and proposal files are a point-in-time
record and should not be read as the current product plan.

The later product decision removes Sparrow rather than retaining it as a
temporary wallet coordinator. PR #216 implements that narrower direction on top
of PR #202. As a result, Sparrow-specific work such as issue #205 and the
Sparrow-only acceptance criteria in this assessment are superseded.

The still-applicable direction is to keep the Bails runtime narrow, remove the
custom wallet layer, authenticate executable and update inputs, document the
supported threat model and handoff boundary, and add focused regression tests.
