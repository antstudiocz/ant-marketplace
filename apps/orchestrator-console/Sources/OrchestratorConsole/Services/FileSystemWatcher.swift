import Darwin
import Foundation

final class FileSystemWatcher {
    private var sources: [DispatchSourceFileSystemObject] = []
    private var descriptors: [CInt] = []
    private let queue = DispatchQueue(label: "orchestrator-console.file-watcher")
    private let onChange: @Sendable () -> Void
    private var pendingWorkItem: DispatchWorkItem?

    init(urls: [URL], onChange: @escaping @Sendable () -> Void) {
        self.onChange = onChange
        for url in urls {
            watch(url)
        }
    }

    deinit {
        invalidate()
    }

    func invalidate() {
        pendingWorkItem?.cancel()
        pendingWorkItem = nil
        sources.forEach { $0.cancel() }
        sources.removeAll()
    }

    private func watch(_ url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let descriptor = open(url.path, O_EVTONLY)
        guard descriptor >= 0 else { return }

        descriptors.append(descriptor)
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: descriptor,
            eventMask: [.write, .delete, .rename, .extend, .attrib],
            queue: queue
        )
        source.setEventHandler { [weak self] in
            self?.scheduleChange()
        }
        source.setCancelHandler {
            close(descriptor)
        }
        sources.append(source)
        source.resume()
    }

    private func scheduleChange() {
        pendingWorkItem?.cancel()
        let workItem = DispatchWorkItem { [onChange] in
            DispatchQueue.main.async {
                onChange()
            }
        }
        pendingWorkItem = workItem
        queue.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
    }
}
