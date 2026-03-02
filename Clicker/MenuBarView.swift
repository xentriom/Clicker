//
//  MenuBarView.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import AppKit
import KeyboardShortcuts
import SwiftUI

struct MenuBarView: View {
  @EnvironmentObject var clickerState: ClickerState
  private var appVersion: String {
    let version =
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      ?? "1.0.0"
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    return "\(version) (\(build))"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Header
      HStack(alignment: .center, spacing: 6) {
        Image(systemName: "cursorarrow.click.2")
          .font(.system(size: 18))
          .foregroundStyle(.secondary)
        VStack(alignment: .leading) {
          Text("Clicker").font(.headline)
          Text("v\(appVersion)")
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        Spacer(minLength: 0)
        Button {
          withAnimation(.snappy) {
            clickerState.toggleClicking()
          }
        } label: {
          Label(
            clickerState.isClicking ? "Stop" : "Start",
            systemImage: clickerState.isClicking ? "stop.fill" : "play.fill"
          )
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .tint(clickerState.isClicking ? .red : .accentColor)
        .help("Start or stop auto-clicking")
      }

      Divider()

      Group {
        // Mouse Button
        VStack(alignment: .leading, spacing: 6) {
          SectionHeader(title: "Mouse Button")
          ExpandingSegmentedControl(
            options: ["Left", "Middle", "Right"],
            selection: Binding(
              get: { clickerState.selectedMouseButton },
              set: { newValue in
                DispatchQueue.main.async {
                  clickerState.selectedMouseButton = newValue
                }
              }
            ),
            disabled: clickerState.isClicking
          )
          .help("Mouse button to simulate")
        }

        // Interval
        VStack(alignment: .leading, spacing: 6) {
          SectionHeader(title: "Click Interval")
          HStack(spacing: 6) {
            IntervalColumn(label: "Hours", value: $clickerState.intervalHours)
            IntervalColumn(
              label: "Minutes",
              value: $clickerState.intervalMinutes
            )
            IntervalColumn(
              label: "Seconds",
              value: $clickerState.intervalSeconds
            )
            IntervalColumn(
              label: "Milliseconds",
              value: $clickerState.intervalMilliseconds
            )
          }
        }

        // Repeat
        VStack(alignment: .leading, spacing: 6) {
          SectionHeader(title: "Repeat Clicks")
          Picker("", selection: $clickerState.repeatMode) {
            Text("Until stopped").tag("infinite")
            HStack(spacing: 6) {
              TextField("", value: $clickerState.repeatCount, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 56)
                .multilineTextAlignment(.center)
                .disabled(clickerState.repeatMode != "limited")
                .onChange(of: clickerState.repeatCount) { _, newValue in
                  clickerState.repeatCount = max(1, newValue)
                }
              Text("times")
            }
            .tag("limited")
          }
          .pickerStyle(.radioGroup)
          .help("When to stop clicking")
        }

        Divider()

        VStack(alignment: .leading, spacing: 6) {
          Toggle("Launch at login", isOn: $clickerState.toLaunchAtLogin)
            .onChange(of: clickerState.toLaunchAtLogin) { _, _ in
              clickerState.applyLaunchAtLogin()
            }
          KeyboardShortcuts.Recorder(
            "Start/Stop shortcut:",
            name: .toggleClicking
          )
        }
      }
      .disabled(clickerState.isClicking)

      Divider()

      Button("Quit Clicker") {
        NSApplication.shared.terminate(nil)
      }
      .buttonStyle(.plain)
      .keyboardShortcut("q")
    }
    .frame(width: 260)
    .padding(12)
  }
}

private struct ExpandingSegmentedControl: NSViewRepresentable {
  let options: [String]
  @Binding var selection: String
  var disabled: Bool = false

  func makeNSView(context: Context) -> NSSegmentedControl {
    let control = NSSegmentedControl(
      labels: options,
      trackingMode: .selectOne,
      target: context.coordinator,
      action: #selector(Coordinator.segmentChanged)
    )
    control.segmentDistribution = .fillEqually
    control.selectedSegment = options.firstIndex(of: selection) ?? 0
    control.isEnabled = !disabled
    return control
  }

  func updateNSView(_ nsView: NSSegmentedControl, context: Context) {
    let index = options.firstIndex(of: selection) ?? 0
    if nsView.selectedSegment != index {
      nsView.selectedSegment = index
    }
    nsView.isEnabled = !disabled
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject {
    var parent: ExpandingSegmentedControl
    init(_ parent: ExpandingSegmentedControl) { self.parent = parent }
    @objc func segmentChanged(_ sender: NSSegmentedControl) {
      let index = sender.selectedSegment
      if index >= 0, index < parent.options.count {
        parent.selection = parent.options[index]
      }
    }
  }
}

private struct SectionHeader: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.subheadline)
      .fontWeight(.semibold)
      .foregroundStyle(.secondary)
  }
}

private struct IntervalColumn: View {
  let label: String
  @Binding var value: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(label)
        .font(.system(size: 9))
        .foregroundStyle(.secondary)
      TextField("", value: $value, format: .number)
        .textFieldStyle(.roundedBorder)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .onChange(of: value) { _, newValue in
          value = min(100, max(0, newValue))
        }
    }
  }
}
