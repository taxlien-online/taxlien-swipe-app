# Requirements: PDF Export for Property Analysis Sheet

**Version:** 1.0
**Status:** DRAFT
**Last Updated:** 2026-01-30

---

## Overview

This document outlines the requirements for implementing the "Export to PDF" feature, allowing users (specifically Miw) to generate a comprehensive Property Analysis Sheet for a given `TaxLien` property. This PDF will be suitable for printing and offline review.

---

## Functional Requirements

### FR-1: PDF Generation Trigger
- **Description:** A clear action button or menu item must be available on the `Property Details Screen` (`DetailsScreen`) to initiate the PDF export process.
- **Location:** `DetailsScreen` (e.g., in the AppBar or as a dedicated FAB).

### FR-2: PDF Content - Property Overview
- **Description:** The PDF should include essential property identification and core data.
- **Includes:**
    - Property Address (e.g., "123 Main St, Phoenix, AZ 85001")
    - County
    - Parcel ID
    - Auction Date
    - Opening Bid
    - Square Footage

### FR-3: PDF Content - ML Scores & FVI
- **Description:** Key analytical scores and the Full Value Index (FVI) breakdown must be presented.
- **Includes:**
    - Foreclosure Probability Score
    - Miw Score
    - Karma Score
    - Prior Years Owed
    - FVI Breakdown: A visual representation of each expert's contribution to the FVI, similar to the `FVIBreakdownChart` in the UI.

### FR-4: PDF Content - Property Images
- **Description:** All available images for the property should be included in the PDF.
- **Details:**
    - Images should be displayed clearly.
    - Consider optimizing image quality for PDF to balance file size and visual fidelity.

### FR-5: PDF Content - Expert Annotations
- **Description:** Any existing expert annotations for the property must be included.
- **Details:**
    - If images with annotations overlays are available, they should be preferred.
    - Otherwise, annotations should be listed textually, detailing the expert, type (point, line, area), and comment.

### FR-6: PDF Content - Property Description
- **Description:** The textual description of the property should be included.

### FR-7: PDF Content - Map Placeholder
- **Description:** A representation of the property's location.
- **Details:** Can be a static map image or a text placeholder indicating "Interactive Map Location".

### FR-8: PDF Format & Styling
- **Description:** The PDF should be well-formatted, professional, and easy to read.
- **Details:**
    - Clear headings and subheadings.
    - Consistent typography.
    - Optimized layout for A4 or Letter paper size.
    - Branding (e.g., "Deal Detective" logo/title).

### FR-9: PDF Export Location
- **Description:** The generated PDF file must be saved to a specific, user-accessible location on the device.
- **Location:** `/data/exports/miw-preview/property_cards/{parcel_id}.pdf` (this implies using `path_provider` for app-specific or shared storage).

### FR-10: Error Handling & User Feedback
- **Description:** The user should receive appropriate feedback during the PDF generation process (e.g., loading indicator) and in case of errors (e.g., "Failed to generate PDF").

---

## Non-Functional Requirements

### NFR-1: Performance
- **Description:** PDF generation should be reasonably fast, especially for properties with many images or annotations.

### NFR-2: Offline Capability
- **Description:** The PDF generation should function correctly even when the device is offline, using cached data and images.

### NFR-3: Security
- **Description:** PDF generation should not expose any sensitive user data or system information.

---

## Out of Scope

- Advanced PDF editing features within the app.
- Direct sharing of PDF to external services (beyond standard OS share sheet).
- Customizable PDF templates by the user.

---

## Acceptance Criteria

- [ ] A button exists on `DetailsScreen` to trigger PDF export.
- [ ] Clicking the button initiates PDF generation.
- [ ] The generated PDF includes all required content: Property details, ML scores, FVI breakdown, images, annotations, description, map placeholder.
- [ ] The PDF is saved to the specified location (`/data/exports/miw-preview/property_cards/{parcel_id}.pdf`).
- [ ] The PDF is readable, well-formatted, and printable.
- [ ] Error messages are displayed to the user if PDF generation fails.
- [ ] The feature works correctly both online and offline.
