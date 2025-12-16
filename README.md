<img width="579" height="1132" alt="Screenshot 2025-12-09 at 11 02 04 PM" src="https://github.com/user-attachments/assets/00f14fa6-2309-4281-afc6-0fb46fc65cff" />



# CreateAbility

CreateAbility is an iOS application designed to help users stay organized, manage time intentionally, and care for their mental well-being without becoming overwhelmed.

The app was designed specifically around a primary user persona, Raven, whose challenges include overstimulation, difficulty with time management, and self-care often taking a back seat. Every feature in CreateAbility directly maps back to these needs.

**User-Centered Design Approach**

CreateAbility was built using a structured design-thinking process documented in our Miro board, moving from research and synthesis to ideation, iteration, and development.

Rather than starting with features, the project began with a clear understanding of the user.

# Primary User Persona: Raven

Raven struggles with the following:

- Staying organized while juggling multiple responsibilities
- Managing time without feeling rushed or guilty
- Becoming overstimulated by cluttered interfaces and excessive notifications
- Letting self-care fall behind during busy periods
  
Design goal:
Help Raven feel supported, focused, and in control rather than pressured.

# Design and Development Process

**Research and Empathy**

Through brainstorming, empathy mapping, and research synthesis, we explored how overstimulation affects productivity and why many traditional productivity tools unintentionally increase stress.

Key insight:
Users like Raven need fewer decisions, calmer visuals, and gentle structure rather than more features.

# Challenge Statement

How might we help users like Raven stay organized and manage time while protecting their mental well-being and prioritizing self-care?

This challenge guided every design and technical decision.

# Ideation and Feature Mapping

Ideas were generated and grouped into core themes reflected on the Miro board:

- Organization without clutter
- Time awareness without pressure
- Emotional reflection
- Accessible self-care
- Features that increased cognitive load were intentionally removed.

# User Flows and Information Architecture

User flows were designed to minimize navigation depth, reduce decision fatigue, and avoid unnecessary interruptions.

The final structure uses a simple bottom navigation layout with clearly defined sections.

Wireframing and Iteration

Low- and mid-fidelity wireframes focused on layout clarity, visual hierarchy, and predictable interactions.

Iterations emphasized calm visual language and reduced sensory load.

# Development and Implementation

The refined designs were implemented using Swift and SwiftUI with a modular view-based architecture.

Each screen maps directly back to a user need identified during research.

**Feature-to-Need Mapping**

**Mood Tracking**

Allows Raven to quickly reflect on emotional state without overthinking.

Addresses:

- Overstimulation
- Emotional overload

# Commitments

Encourages meaningful intentions instead of overwhelming task lists.

Addresses:

- Staying organized
- Time management

**Calendar View**

Provides a high-level view of progress without micromanagement.

Addresses:

- Time awareness without guilt

# Self-Care

Creates a dedicated space so self-care does not get forgotten.

Addresses:

- Self-care taking a back seat

# Settings

Allows the user to control the experience and reduce unnecessary stimuli.

Addresses:

- Overstimulation
- Personalization needs

# Design Decisions Informed by Raven

Minimal color palette to reduce sensory overload
Large, readable text for cognitive ease
No productivity streaks or pressure-based metrics
Clear separation between reflection and action
Each decision was made to protect the user’s focus and mental energy.

# Technical Overview

- Platform: iOS
- Language: Swift
- Framework: SwiftUI
- Architecture: Modular SwiftUI views
- State management: View-based state updates
- The codebase is structured for clarity, maintainability, and future expansion.

# Project Structure

createablity: Assets: description: Visual assets MoodPage.swift: description: Emotional reflection CommitmentsPage.swift: description: Intentional organization CalendarPage.swift: description: Time awareness SelfCarePage.swift: description: Wellness support SettingsPage.swift: description: Customization NavigationView.swift: description: App navigation FinalAppView.swift: description: Root view

# Future Improvements

- Adding to Apple Intellegence & Vision Pro
- Gentle reminders and notifications
- Mood trend visualization
- Accessibility refinements
- Optional personalization features

# Final Reflection

CreateAbility demonstrates how user research can directly inform both design and engineering decisions.

By grounding the app in Raven’s real challenges, including overstimulation, time pressure, and neglected self-care, the final product remains intentional, calm, and human.

This project represents an end-to-end, user-centered development process from empathy to execution.
