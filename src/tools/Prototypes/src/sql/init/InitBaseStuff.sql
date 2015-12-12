

INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Unsatisfactory', '', 1)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Basic', '', 2)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Proficient', '', 3)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Distinguished', '', 4)

INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('TState', '', 1, 2, 3, 4, 1, 0)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('TInstructional', '', 1, 2, 3, 4, 0, 0)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('PState', '', 1, 2, 3, 4, 1, 1)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('PInstructional', '', 1, 2, 3, 4, 0, 1)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('TSState', '', 1, 2, 3, 4, 1, 0)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('TSInstructional', '', 1, 2, 3, 4, 0, 0)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('PSState', '', 1, 2, 3, 4, 1, 1)
INSERT SEFrameworkType(Name, Description, RubricPL1ID, RubricPL2ID, RubricPL3ID, RubricPL4ID, IsStateFramework, IsPrincipalEval)
VALUES('PSInstructional', '', 1, 2, 3, 4, 0, 1)

INSERT SEFrameworkViewType(Name) VALUES('State Framework Only')
INSERT SEFrameworkViewType(Name) VALUES('State Framework Default')
INSERT SEFrameworkViewType(Name) VALUES('Instructional Framework Default')

