//
//  ViewModelInjectables.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
protocol HomeViewModelInjectable { var homeViewModel: HomeViewModelType { get } }
protocol ContactDetailViewModelInjectable { var contactDetailViewModel: ContactDetailViewModelType { get } }
