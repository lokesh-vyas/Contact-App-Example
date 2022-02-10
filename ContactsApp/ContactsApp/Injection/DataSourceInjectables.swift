//
//  DataSourceInjectables.swift
//  ContactsApp
//
//  Created by Lokesh Vyas on 21/01/22.
//

import Foundation
protocol ContactLocalDataSourceInjectable { var contactLocalDataSource: ContactLocalDataSource { get } }
protocol ContactRemoteDataSourceInjectable { var contactRemoteDataSource: ContactRemoteDataSource { get } }
