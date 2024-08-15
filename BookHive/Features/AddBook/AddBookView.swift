//
// AddBookView.swift
// Created by Arpit Williams on 13/08/24.
//

import ComposableArchitecture
import SwiftUI

struct AddBookView: View {

  @Perception.Bindable var store: StoreOf<AddBookStore>
  init(store: StoreOf<AddBookStore>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      NavigationView {
        Form {
          textInputs
          dateInput
          buttons
        }
        .navigationBarTitle("Add Book 📚")
      }
    }
  }

  var textInputs: some View {
    Section(
      header: Text("Book Details")
        .font(.callout).fontWeight(.semibold)
    ) {
      TextField("Title", text: $store.title)
      TextField("Author", text: $store.author)
      TextField("Description", text: $store.description)
    }
  }

  var dateInput: some View {
    Section(
      header: Text("Published Date")
        .font(.callout).fontWeight(.semibold)
    ) {
      DatePicker(
        "Pick a Date",
        selection: $store.publishedDate,
        displayedComponents: .date
      )
    }
  }

  var buttons: some View {
    VStack(spacing: 16) {
      Button(
        action: { store.send(.createBook) },
        label: {
          Text("Save Book")
            .textCase(.uppercase)
            .font(.body.weight(.semibold))
        }
      )

      Divider()

      Button(
        action: { store.send(.dismiss) },
        label: {
          Text("Cancel")
            .textCase(.uppercase)
            .font(.callout.weight(.semibold))
            .foregroundColor(Color(.systemPink))
        }
      )
    }
    .buttonStyle(BorderlessButtonStyle())
    .frame(maxWidth: .infinity, alignment: .center)
  }
}

#Preview {
  AddBookView(
    store: AddBookStore.mockStore()
  )
}
